--------------- SQL ---------------

CREATE OR REPLACE FUNCTION kaf.ft_clasificacion_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Activos Fijos - K
 FUNCION: 		kaf.ft_clasificacion_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'kaf.tclasificacion'
 AUTOR: 		 (admin)
 FECHA:	        09-11-2015 01:22:17
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'kaf.ft_clasificacion_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'SKA_CLAF_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin
 	#FECHA:		09-11-2015 01:22:17
	***********************************/

	if(p_transaccion='SKA_CLAF_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                            claf.id_clasificacion,
                            claf.codigo,
                            claf.nombre,
                            claf.final,
                            claf.estado_reg,
                            claf.id_cat_metodo_dep,
                            claf.tipo,
                            claf.id_concepto_ingas,
                            claf.monto_residual,
                            claf.icono,
                            claf.id_clasificacion_fk,
                            claf.vida_util,
                            claf.correlativo_act,
                            claf.usuario_ai,
                            claf.fecha_reg,
                            claf.id_usuario_reg,
                            claf.id_usuario_ai,
                            claf.id_usuario_mod,
                            claf.fecha_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            cat.codigo as codigo_met_dep,
                            cat.descripcion as met_dep,
                            cig.desc_ingas,
                            claf.codigo||'' - ''||claf.nombre as clasificacion,
                            claf.descripcion,
                            claf.tipo_activo,
                            claf.depreciable,
                            claf.contabilizar,
                            (select kaf.f_get_codigo_clasificacion_rec(claf.id_clasificacion)) as codigo_final,
                            round(claf.vida_util / 12,2)::numeric as vida_util_anios
						from kaf.tclasificacion claf
						inner join segu.tusuario usu1 on usu1.id_usuario = claf.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = claf.id_usuario_mod
						left join param.tcatalogo cat on cat.id_catalogo = claf.id_cat_metodo_dep
						left join param.tconcepto_ingas cig on cig.id_concepto_ingas = claf.id_concepto_ingas
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'SKA_CLAF_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin
 	#FECHA:		09-11-2015 01:22:17
	***********************************/

	elsif(p_transaccion='SKA_CLAF_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_clasificacion)
					    from kaf.tclasificacion claf
						inner join segu.tusuario usu1 on usu1.id_usuario = claf.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = claf.id_usuario_mod
						left join param.tcatalogo cat on cat.id_catalogo = claf.id_cat_metodo_dep
						left join param.tconcepto_ingas cig on cig.id_concepto_ingas = claf.id_concepto_ingas
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'SKA_CLAFARB_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:			admin
 	#FECHA:			09-11-2015 01:22:17
	***********************************/

	elsif(p_transaccion='SKA_CLAFARB_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
                            claf.id_clasificacion,
                            claf.codigo,
                            claf.nombre,
                            claf.final,
                            claf.estado_reg,
                            claf.id_cat_metodo_dep,
                            claf.tipo,
                            claf.id_concepto_ingas,
                            claf.monto_residual,
                            claf.icono,
                            claf.id_clasificacion_fk,
                            claf.vida_util,
                            claf.correlativo_act,
                            claf.usuario_ai,
                            claf.fecha_reg,
                            claf.id_usuario_reg,
                            claf.id_usuario_ai,
                            claf.id_usuario_mod,
                            claf.fecha_mod,
                            usu1.cuenta as usr_reg,
                            usu2.cuenta as usr_mod,
                            cat.codigo as codigo_met_dep,
                            cat.descripcion as met_dep,
                            cig.desc_ingas,
                            case
                            when (claf.id_clasificacion_fk is null) then
                                ''raiz''::varchar
                            else
                                ''hijo''::varchar
                            end as tipo_nodo,
                            ''false''::varchar as checked,
                            claf.descripcion,
                            claf.tipo_activo,
                            claf.depreciable,
                            claf.contabilizar,
                            claf.codigo_completo_tmp as codigo_final,
                            round(claf.vida_util / 12,2)::numeric as vida_util_anios
						from kaf.tclasificacion claf
						inner join segu.tusuario usu1 on usu1.id_usuario = claf.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = claf.id_usuario_mod
						left join param.tcatalogo cat on cat.id_catalogo = claf.id_cat_metodo_dep
						left join param.tconcepto_ingas cig on cig.id_concepto_ingas = claf.id_concepto_ingas
				        where ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro || ' ORDER BY claf.codigo ';
			raise notice '%',v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;

    /*********************************
    #TRANSACCION:  'SKA_CLAFTREE_SEL'
    #DESCRIPCION:   Devuelve listado recursivo de toda la clasificación con niveles visuales
    #AUTOR:         RCM
    #FECHA:         25/07/2017
    ***********************************/

    elsif(p_transaccion='SKA_CLAFTREE_SEL')then

        begin
            --Sentencia de la consulta
            v_consulta:='select
                            claf.id_clasificacion,
                            claf.id_clasificacion_fk,
                            claf.clasificacion,
                            claf.nivel,
                            cla.tipo_activo,
                            cla.depreciable,
                            cla.vida_util,
                            cla1.nombre,
                            cla2.nombre
                        from kaf.vclasificacion_arbol claf
                        inner join kaf.tclasificacion cla
                        on cla.id_clasificacion = claf.id_clasificacion
                        left join kaf.tclasificacion cla1
                        on cla1.codigo_completo_tmp = (string_to_array(claf.codigo, ''.''))[1]||''.''||(string_to_array(claf.codigo, ''.''))[2]
                        left join kaf.tclasificacion cla2
                        on cla2.codigo_completo_tmp = (string_to_array(claf.codigo, ''.''))[1]||''.''||(string_to_array(claf.codigo, ''.''))[2]||''.''||(string_to_array(claf.codigo, ''.''))[3]
                        where  ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --Devuelve la respuesta
            return v_consulta;

        end;

    /*********************************
    #TRANSACCION:  'SKA_CLAFTREE_CONT'
    #DESCRIPCION:   Conteo de registros
    #AUTOR:         RCM
    #FECHA:         25/07/2017
    ***********************************/

    elsif(p_transaccion='SKA_CLAFTREE_CONT')then

        begin
            --Sentencia de la consulta de conteo de registros
            v_consulta:='select count(1)
                        from kaf.vclasificacion_arbol claf
                        left join kaf.tclasificacion cla1
                        on cla1.codigo_completo_tmp = (string_to_array(claf.codigo, ''.''))[1]||''.''||(string_to_array(claf.codigo, ''.''))[2]
                        left join kaf.tclasificacion cla2
                        on cla2.codigo_completo_tmp = (string_to_array(claf.codigo, ''.''))[1]||''.''||(string_to_array(claf.codigo, ''.''))[2]||''.''||(string_to_array(claf.codigo, ''.''))[3]
                        where ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;

            --Devuelve la respuesta
            return v_consulta;

        end;

	else

		raise exception 'Transaccion inexistente';

	end if;

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