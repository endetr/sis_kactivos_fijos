<?php
/**
*@package pXP
*@file MODReportes.php
*@author  RCM
*@date 27/07/2017
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODReportes extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function reporteKardex(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='kaf.f_reportes_af';
		$this->transaccion='SKA_KARD_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		if($this->objParam->getParametro('tipo_salida')!='grid'){
			$this->setCount(false);
		}

		//Define los parametros para la funcion
		$this->setParametro('id_activo_fijo','id_activo_fijo','integer');
		$this->setParametro('tipo_salida','tipo_salida','varchar');
		$this->setParametro('fecha_desde','fecha_desde','date');
		$this->setParametro('fecha_hasta','fecha_hasta','date');
		$this->setParametro('id_moneda','id_moneda','integer');
		$this->setParametro('af_estado_mov','af_estado_mov','varchar');
				
		//Definicion de la lista del resultado del query
		$this->captura('codigo','VARCHAR');
		$this->captura('denominacion','VARCHAR');
		$this->captura('fecha_compra','DATE');
		$this->captura('fecha_ini_dep','DATE');
		$this->captura('estado','VARCHAR');
		$this->captura('vida_util_original','INTEGER');
		$this->captura('porcentaje_dep','INTEGER');
		$this->captura('ubicacion','VARCHAR');
		$this->captura('monto_compra_orig','NUMERIC');
		$this->captura('moneda','VARCHAR');
		$this->captura('nro_cbte_asociado','VARCHAR');
		$this->captura('fecha_cbte_asociado','DATE');
		$this->captura('monto_compra_orig_100','NUMERIC');
		$this->captura('valor_actual','NUMERIC');
		$this->captura('vida_util_residual','INTEGER');
		$this->captura('cod_clasif','VARCHAR');
		$this->captura('desc_clasif','VARCHAR');
		$this->captura('metodo_dep','VARCHAR');
		$this->captura('ufv_fecha_compra','NUMERIC');
		$this->captura('responsable','TEXT');
		$this->captura('cargo','VARCHAR');
		$this->captura('fecha_mov','DATE');
		$this->captura('num_tramite','VARCHAR');
		$this->captura('desc_mov','VARCHAR');
		$this->captura('codigo_mov','VARCHAR');
		$this->captura('ufv_mov','NUMERIC');
		$this->captura('id_activo_fijo','INTEGER');
		$this->captura('id_movimiento','INTEGER');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//echo $this->consulta;exit;
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

	function reporteGralAF(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='kaf.f_reportes_af';
		$this->transaccion='SKA_GRALAF_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		if($this->objParam->getParametro('tipo_salida')!='grid'){
			$this->setCount(false);
		}

		//Define los parametros para la funcion
		$this->setParametro('reporte','reporte','varchar');
		$this->setParametro('tipo_salida','tipo_salida','varchar');
		$this->setParametro('fecha_desde','fecha_desde','date');
		$this->setParametro('fecha_hasta','fecha_hasta','date');
		$this->setParametro('id_moneda','id_moneda','integer');
		$this->setParametro('af_estado_mov','af_estado_mov','varchar');

		//Definicion de la lista del resultado del query
		$this->captura('codigo','VARCHAR');
		$this->captura('denominacion','VARCHAR');
		$this->captura('descripcion','VARCHAR');
		$this->captura('fecha_ini_dep','DATE');
		$this->captura('monto_compra_orig_100','numeric');
		$this->captura('monto_compra_orig','numeric');
		$this->captura('ubicacion','varchar');
		$this->captura('responsable','text');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//echo $this->consulta;exit;
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>