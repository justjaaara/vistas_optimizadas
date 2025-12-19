 ALTER VIEW [prime].[VW_MMCARRMT_DATOSINTERFAZ] AS
 
-- Project : PRIME Integraciones 1E - SAP ECC
-- Purpose : Caracteristicas Repuestos motos 1E - MM
-- Author  : TELLA Consulting
-- Created : 06/10/2025
-- Aplica  : 1E
 
SELECT SUBSTRING(concat(TRIM(t120.f120_referencia),' ',(SELECT    ' ' + TRIM (t116.f116_descripcion_corta)
													  + ' ' + TRIM (t117.f117_descripcion_corta)
													  + ' ' + TRIM (t118.f118_descripcion_corta)
													  + ' ' + t121.f121_id_ext2_detalle
												FROM UNOEE_FANALCA.dbo.t116_mc_extensiones1 t116
											   INNER JOIN UNOEE_FANALCA.dbo.t117_mc_extensiones1_detalle t117 ON t116.f116_id_cia = t117.f117_id_cia
											   INNER JOIN UNOEE_FANALCA.dbo.t118_mc_extensiones2 t118 ON t116.f116_id_cia = t118.f118_id_cia
											   WHERE t116.f116_id_cia = t120.f120_id_cia
												 AND t116.f116_id = t120.f120_id_extension1
												 AND t117.f117_id_cia = t121.f121_id_cia
												 AND t117.f117_id = t121.f121_id_ext1_detalle
												 AND t117.f117_id_extension1 = t121.f121_id_extension1
												 AND t118.f118_id = t121.f121_id_extension2
											 )
	                   ),1,40) mmcm16,
       'REP_MOD_APLICABLES' caracteristica,
       prime.f_criterio_item (t120.f120_id_cia, t120.f120_rowid, 'H20') valor
  FROM UNOEE_FANALCA.dbo.t120_mc_items t120
INNER JOIN UNOEE_FANALCA.dbo.t121_mc_items_extensiones t121 ON t120.f120_id_cia = t121.f121_id_cia
       AND t120.f120_rowid = t121.f121_rowid_item
INNER JOIN detalleinterfaz deti 
       ON TRIM(deti.intf_item) = TRIM(SUBSTRING(concat(TRIM(t120.f120_referencia),' ',(SELECT    ' ' + TRIM (t116.f116_descripcion_corta)
																							  + ' ' + TRIM (t117.f117_descripcion_corta)
																							  + ' ' + TRIM (t118.f118_descripcion_corta)
																							  + ' ' + t121.f121_id_ext2_detalle
																						FROM UNOEE_FANALCA.dbo.t116_mc_extensiones1 t116
																					   INNER JOIN UNOEE_FANALCA.dbo.t117_mc_extensiones1_detalle t117 
																					         ON t116.f116_id_cia = t117.f117_id_cia
																					   INNER JOIN UNOEE_FANALCA.dbo.t118_mc_extensiones2 t118
																					         ON t116.f116_id_cia = t118.f118_id_cia
																					   WHERE t116.f116_id_cia = t120.f120_id_cia
																						 AND t116.f116_id = t120.f120_id_extension1
																						 AND t117.f117_id_cia = t121.f121_id_cia
																						 AND t117.f117_id = t121.f121_id_ext1_detalle
																						 AND t117.f117_id_extension1 = t121.f121_id_extension1
																						 AND t118.f118_id = t121.f121_id_extension2
																					 )
												),1,40)
									)
       AND CONVERT(date,deti.deti_fechamov) IN (CONVERT(date,t120.f120_fecha_creacion),CONVERT(date,t120.f120_fecha_actualizacion))
INNER JOIN ge_tparametros intf ON intf.parm_consecutivo = deti.parm_interfaz
INNER JOIN ge_tparametros modu ON modu.parm_consecutivo = intf.parm_padre
WHERE t120.f120_id_cia = 1
   AND prime.f_criterio_item (t120.f120_id_cia, t120.f120_rowid, 'H20') <> 'NO ESPECIFICADO'         --Filtro consulta Modelo Motos
   AND deti.intf_consecutivo = (SELECT vhpg.vhpg_valor
                                  FROM vlrsprmgrales vhpg
                                 WHERE vhpg.pmgr_parametro = 'MMMAEMT_CONSINT'
                                   AND vhpg.vhpg_estado = 1)
   AND intf.parm_codigo = 2
   AND modu.parm_descripcion = 'MM'
UNION ALL
SELECT SUBSTRING(concat(TRIM(t120.f120_referencia),' ',(SELECT    ' ' + TRIM (t116.f116_descripcion_corta)
																+ ' ' + TRIM (t117.f117_descripcion_corta)
																+ ' ' + TRIM (t118.f118_descripcion_corta)
																+ ' ' + t121.f121_id_ext2_detalle
														FROM UNOEE_FANALCA.dbo.t116_mc_extensiones1 t116
														INNER JOIN UNOEE_FANALCA.dbo.t117_mc_extensiones1_detalle t117 
														      ON t116.f116_id_cia = t117.f117_id_cia
														INNER JOIN UNOEE_FANALCA.dbo.t118_mc_extensiones2 t118 
														       ON t116.f116_id_cia = t118.f118_id_cia
														WHERE t116.f116_id_cia = t120.f120_id_cia
															AND t116.f116_id = t120.f120_id_extension1
															AND t117.f117_id_cia = t121.f121_id_cia
															AND t117.f117_id = t121.f121_id_ext1_detalle
															AND t117.f117_id_extension1 = t121.f121_id_extension1
															AND t118.f118_id = t121.f121_id_extension2
														)
	                   ),1,40)  mmcm16,
       'REP_REF_EQUIVALENTES' caracteristica,
       t1201.f120_referencia valor
  FROM UNOEE_FANALCA.dbo.t120_mc_items t120
INNER JOIN UNOEE_FANALCA.dbo.t121_mc_items_extensiones t121 ON t120.f120_id_cia = t121.f121_id_cia
       AND t120.f120_rowid = t121.f121_rowid_item
INNER JOIN UNOEE_FANALCA.dbo.t128_mc_items_equivalentes t128 ON t128.f128_rowid_item = t120.f120_rowid
INNER JOIN UNOEE_FANALCA.dbo.t120_mc_items t1201 ON t1201.f120_id_cia = t128.f128_id_cia
       AND t1201.f120_rowid = t128.f128_rowid_item_equivalente
INNER JOIN detalleinterfaz deti 
       ON TRIM(deti.intf_item) = TRIM(SUBSTRING(concat(TRIM(t120.f120_referencia),' ',(SELECT    ' ' + TRIM (t116.f116_descripcion_corta)
																							  + ' ' + TRIM (t117.f117_descripcion_corta)
																							  + ' ' + TRIM (t118.f118_descripcion_corta)
																							  + ' ' + t121.f121_id_ext2_detalle
																						FROM UNOEE_FANALCA.dbo.t116_mc_extensiones1 t116
																					   INNER JOIN UNOEE_FANALCA.dbo.t117_mc_extensiones1_detalle t117 
																					         ON t116.f116_id_cia = t117.f117_id_cia
																					   INNER JOIN UNOEE_FANALCA.dbo.t118_mc_extensiones2 t118
																					         ON t116.f116_id_cia = t118.f118_id_cia
																					   WHERE t116.f116_id_cia = t120.f120_id_cia
																						 AND t116.f116_id = t120.f120_id_extension1
																						 AND t117.f117_id_cia = t121.f121_id_cia
																						 AND t117.f117_id = t121.f121_id_ext1_detalle
																						 AND t117.f117_id_extension1 = t121.f121_id_extension1
																						 AND t118.f118_id = t121.f121_id_extension2
																					 )
	                                              ),1,40)
				                       )
       AND CONVERT(date,deti.deti_fechamov) IN (CONVERT(date,t120.f120_fecha_creacion),CONVERT(date,t120.f120_fecha_actualizacion))
INNER JOIN ge_tparametros intf ON intf.parm_consecutivo = deti.parm_interfaz
INNER JOIN ge_tparametros modu ON modu.parm_consecutivo = intf.parm_padre
WHERE t120.f120_id_cia = 1
   AND prime.f_criterio_item (t120.f120_id_cia, t120.f120_rowid, 'H20') <> 'NO ESPECIFICADO'        --Filtro consulta Modelo Motos
   AND deti.intf_consecutivo = (SELECT vhpg.vhpg_valor
                                  FROM vlrsprmgrales vhpg
                                 WHERE vhpg.pmgr_parametro = 'MMMAEMT_CONSINT'
                                   AND vhpg.vhpg_estado = 1)
   AND intf.parm_codigo = 2
   AND modu.parm_descripcion = 'MM';
GO