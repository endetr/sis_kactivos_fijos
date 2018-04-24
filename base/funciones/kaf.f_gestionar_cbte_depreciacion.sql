CREATE OR REPLACE FUNCTION kaf.f_gestionar_cbte_depreciacion (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_int_comprobante integer,
  p_conexion varchar = NULL::character varying
)
RETURNS boolean AS
$body$
/****************************************************************************
Autor: RAC KPLIAN
Fecha:   03/05/2017
Descripcion  Esta funcion gestiona los cbtes de depreciacon cuando son validados          

*****************************************************************************
HISTORIAL DE MODIFICACIONES


Autor: RCM
Fecha: 24/04/2018
Descripción: Se modifica la función por la generación de 3 comprobantes para ETR
*****************************************************************************/

DECLARE

    v_nombre_funcion            text;
    v_resp                      varchar;
    v_registros                 record;
    v_id_estado_actual          integer;
    va_id_tipo_estado           integer[];
    va_codigo_estado            varchar[];
    va_disparador               varchar[];
    va_regla                    varchar[]; 
    va_prioridad                integer[];    
    v_id_proceso_wf             integer;
    v_id_estado_wf              integer;
    v_codigo_estado             varchar;
    v_id_tipo_estado            integer;
    v_codigo_proceso_llave_wf   varchar;
    v_id_int_comprobante        integer;
    v_sw_fin                    boolean = false;
    v_estado_1                  varchar;
    v_estado_2                  varchar;
    v_estado_3                  varchar;

BEGIN

    v_nombre_funcion = 'kaf.f_gestionar_cbte_depreciacion';
 
    --1) Obtención de datos
    select 
    mov.id_movimiento,
    mov.id_estado_wf,
    mov.id_proceso_wf,
    mov.estado,
    mov.fecha_mov,
    ew.id_funcionario,
    ew.id_depto,
    mov.id_int_comprobante,
    mov.id_int_comprobante_aitb,
    cat.codigo as movimiento
    into
    v_registros
    from  kaf.tmovimiento mov      
    inner join wf.testado_wf ew 
    on ew.id_estado_wf = mov.id_estado_wf
    inner join param.tcatalogo cat
    on cat.id_catalogo = mov.id_cat_movimiento
    where mov.id_int_comprobante = p_id_int_comprobante
    or mov.id_int_comprobante_aitb = p_id_int_comprobante
    or mov.id_int_comprobante = p_id_int_comprobante; 
    
    --2) Valida que el comprobante esté relacionado con un movimiento
    if v_registros.id_movimiento is null then
      raise exception 'El comprobante no está relacionado con ningún movimiento de activos fijos';
    end if;
    
    --3) Verificación de validación de los 3 comprobantes
    select estado_reg
    into v_estado_1 
    from conta.tint_comprobante
    where id_int_comprobante = v_registros.id_int_comprobante;
    
    select estado_reg
    into v_estado_2
    from conta.tint_comprobante
    where id_int_comprobante = v_registros.id_int_comprobante_aitb;
    
    select estado_reg
    into v_estado_3
    from conta.tint_comprobante
    where id_int_comprobante = v_registros.id_int_comprobante_3;
    
    if v_registros.movimiento = 'deprec' then
        if coalesce(v_estado_1,'')='validado' and coalesce(v_estado_2,'')='validado' and coalesce(v_estado_3,'')='validado' then
            v_sw_fin = true;
        end if;
    elsif v_registros.movimiento = 'actua' then
        if coalesce(v_estado_1,'')='validado' then
            v_sw_fin = true;
        end if;
    else
        raise exception 'El movimiento debe ser Depreciación o Actualización';
    end if;
    
    
     --4) Finaliza el movimiento si es que los 3 comprobantes de depreciación generados han sido validados
     if v_sw_fin then
        --------------------------------------------------------
        ---  Cambiar el estado del movimiento              -----
        --------------------------------------------------------
        --Obtiene el siguiente estado del flujo 
        select
        *
        into
        va_id_tipo_estado,
        va_codigo_estado,
        va_disparador,
        va_regla,
        va_prioridad
        from wf.f_obtener_estado_wf(v_registros.id_proceso_wf, v_registros.id_estado_wf,null,'siguiente');
              
        if va_codigo_estado[2] is not null then
          raise exception 'El proceso de WF esta mal parametrizado, sólo admite un estado siguiente para el estado: %', v_registros.estado;
        end if;
                      
        if va_codigo_estado[1] is null then
          raise exception 'El proceso de WF esta mal parametrizado, no se encuentra el estado siguiente, para el estado: %', v_registros.estado;           
        end if;
              
        --Estado siguiente
        v_id_estado_actual = wf.f_registra_estado_wf(va_id_tipo_estado[1], 
                                                    v_registros.id_funcionario, 
                                                    v_registros.id_estado_wf, 
                                                    v_registros.id_proceso_wf,
                                                    p_id_usuario,
                                                    p_id_usuario_ai, -- id_usuario_ai
                                                    p_usuario_ai, -- usuario_ai
                                                    v_registros.id_depto_conta,
                                                    'Comprobantes de depreciación validados');

        --Actualiza estado del proceso
        update kaf.tmovimiento mov  set 
        id_estado_wf =  v_id_estado_actual,
        estado = va_codigo_estado[1],
        id_usuario_mod = p_id_usuario,
        fecha_mod = now(),
        id_usuario_ai = p_id_usuario_ai,
        usuario_ai = p_usuario_ai
        where mov.id_movimiento = v_registros.id_movimiento; 

    end if;
      
    --Respuesta
    return true;

EXCEPTION
          
  WHEN OTHERS THEN
          v_resp='';
          v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
          v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
          v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
          raise exception '%',v_resp;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;