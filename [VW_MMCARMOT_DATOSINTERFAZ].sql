

ALTER   VIEW [prime].[VW_MMCARMOT_DATOSINTERFAZ] AS

-- Project : PRIME Integraciones 1E - SAP ECC
-- Purpose : Caracteristicas motos 1E - MM
-- Author  : TELLA Consulting
-- Created : 06/10/2025
-- Aplica  : 1E

SELECT DISTINCT SUBSTRING(CASE WHEN CHARINDEX('MOTOCICLETA',f120_descripcion) > 0 THEN
	   		  	                    REPLACE(f120_descripcion, 'MOTOCICLETA ', '')
	   				           WHEN CHARINDEX('MOTOCICLETA',f120_descripcion) > 0 THEN
	   				   		        REPLACE(f120_descripcion, 'MOTOCICLETA', '')
	   				           WHEN CHARINDEX('MOTO',f120_descripcion) > 0 THEN
	   				   		        REPLACE(f120_descripcion, 'MOTO ', '')
	   				           ELSE TRIM(f120_descripcion)
	   				      END
				          + ' ' + REPLACE(f417_campo_5, char(13) + char(10), '')
				          + ' ' + REPLACE(f117_descripcion, char(13) + char(10), ''),1,40) mmcm16,
                'MOT_MARCA' caracteristica,
			    (SELECT hmlg.hmlg_codigosap
				   FROM vw_homologacionessap hmlg
				  WHERE hmlg.legacy = 'UNOEE'
                    AND hmlg.parm_tipohomologacion = 42
                    AND hmlg.hmlg_codigolegacy = TRIM(prime.f_criterio_item_prime (t120.f120_id_cia,t120.f120_rowid,'200'))) valor     -- Homologacion
  FROM UNOEE_FANALCA.dbo.t417_cm_seriales t417
 INNER JOIN UNOEE_FANALCA.dbo.t121_mc_items_extensiones t121 ON t417.f417_id_cia = t121.f121_id_cia
       AND t417.f417_rowid_item_ext = t121.f121_rowid
 INNER JOIN UNOEE_FANALCA.dbo.t120_mc_items t120 ON t120.f120_rowid = t121.f121_rowid_item
 INNER JOIN UNOEE_FANALCA.dbo.t117_mc_extensiones1_detalle t117 ON t117.f117_id_cia = t121.f121_id_cia
       AND t117.f117_id = t121.f121_id_ext1_detalle
 WHERE t417.f417_id_cia = 1
   AND t417.f417_id_cfg_serial IN ('01','02','03','04','JA739','KF579','NC609') -- Filtro serial materiales
   AND t417.f417_campo_1 IS NOT NULL
   AND t417.f417_campo_5 IS NOT NULL
   AND t120.f120_ind_venta = 1
   AND ( (TRIM(SUBSTRING(CASE WHEN CHARINDEX('MOTOCICLETA',f120_descripcion) > 0 THEN
                                   REPLACE(f120_descripcion,'MOTOCICLETA ','')
                              WHEN CHARINDEX('MOTOCICLETA',f120_descripcion) > 0 THEN
                                   REPLACE(f120_descripcion,'MOTOCICLETA','')
                              WHEN CHARINDEX('MOTO',f120_descripcion) > 0 THEN
                                   REPLACE(f120_descripcion, 'MOTO ', '')
                              ELSE TRIM(f120_descripcion)
                         END
				         + ' ' + REPLACE(f417_campo_5, char(13) + char(10), '')
				         + ' ' + REPLACE(f117_descripcion, char(13) + char(10), ''),1,40)
		 	  )
	     ) IN (SELECT TRIM(intf_item)
                 FROM detalleinterfaz deti, interfaces inter
                WHERE deti.intf_consecutivo = inter.intf_consecutivo
                  AND inter.intf_consecutivo = (SELECT vhpg_valor
                                                  FROM vlrsprmgrales
                                                 WHERE pmgr_parametro = 'MMMAEMT_CONSINT')
                  AND deti.parm_interfaz = (SELECT intf.parm_consecutivo
                                              FROM ge_tparametros intf
                                             INNER JOIN ge_tparametros modu ON modu.parm_consecutivo = intf.parm_padre
                                             INNER JOIN ge_tclasesparametros clap ON clap.clap_clase = modu.clap_clase
                                                   AND clap.clap_nombre = 'SAPMODULOSERP'
                                             WHERE modu.parm_descripcion = 'MM'
                                               AND intf.parm_codigo = 2)
			  )
        AND CONVERT(date,t120.f120_fecha_creacion) IN 
		    (SELECT CONVERT(date,deti_fechamov)
               FROM detalleinterfaz deti, interfaces inter
              WHERE deti.intf_consecutivo = inter.intf_consecutivo
                AND inter.intf_consecutivo = (SELECT vhpg_valor
                                                FROM vlrsprmgrales
                                               WHERE pmgr_parametro = 'MMMAEMT_CONSINT')
                AND deti.parm_interfaz = (SELECT intf.parm_consecutivo
                                            FROM ge_tparametros intf
                                           INNER JOIN ge_tparametros modu ON modu.parm_consecutivo = intf.parm_padre
                                           INNER JOIN ge_tclasesparametros clap ON clap.clap_clase = modu.clap_clase
                                                 AND clap.clap_nombre = 'SAPMODULOSERP'
                                           WHERE modu.parm_descripcion = 'MM'
                                             AND intf.parm_codigo = 2)
			)
       )
    OR ( (TRIM(SUBSTRING(CASE WHEN CHARINDEX('MOTOCICLETA',f120_descripcion) > 0 THEN
                                   REPLACE(f120_descripcion, 'MOTOCICLETA ', '')
                              WHEN CHARINDEX('MOTOCICLETA',f120_descripcion) > 0 THEN
                                   REPLACE(f120_descripcion, 'MOTOCICLETA', '')
                              WHEN CHARINDEX('MOTO',f120_descripcion) > 0 THEN
                                   REPLACE(f120_descripcion, 'MOTO ', '')
                              ELSE TRIM(f120_descripcion)
                         END
				 + ' ' + REPLACE(f417_campo_5, char(13) + char(10), '')
				 + ' ' + REPLACE(f117_descripcion, char(13) + char(10), ''),1,40)
              )
	     ) IN (SELECT TRIM(intf_item)
                 FROM detalleinterfaz deti, interfaces inter
                WHERE deti.intf_consecutivo = inter.intf_consecutivo
                  AND inter.intf_consecutivo = (SELECT vhpg_valor
                                                  FROM vlrsprmgrales
                                                 WHERE pmgr_parametro = 'MMMAEMT_CONSINT')
                  AND deti.parm_interfaz = (SELECT intf.parm_consecutivo
                                              FROM ge_tparametros intf
                                             INNER JOIN ge_tparametros modu ON modu.parm_consecutivo = intf.parm_padre
                                             INNER JOIN ge_tclasesparametros clap ON clap.clap_clase = modu.clap_clase
                                                   AND clap.clap_nombre = 'SAPMODULOSERP'
                                             WHERE modu.parm_descripcion = 'MM'
                                               AND intf.parm_codigo = 2)
	          )
        AND CONVERT(date,t120.f120_fecha_actualizacion) IN 
		    (SELECT CONVERT(date,deti_fechamov)
               FROM detalleinterfaz deti, interfaces inter
              WHERE deti.intf_consecutivo = inter.intf_consecutivo
                AND inter.intf_consecutivo = (SELECT vhpg_valor
                                                FROM vlrsprmgrales
                                               WHERE pmgr_parametro = 'MMMAEMT_CONSINT')
                AND deti.parm_interfaz = (SELECT intf.parm_consecutivo
                                            FROM ge_tparametros intf
                                           INNER JOIN ge_tparametros modu ON modu.parm_consecutivo = intf.parm_padre
                                           INNER JOIN ge_tclasesparametros clap ON clap.clap_clase = modu.clap_clase
                                                 AND clap.clap_nombre = 'SAPMODULOSERP'
                                           WHERE modu.parm_descripcion = 'MM'
                                             AND intf.parm_codigo = 2)
			)
		)
UNION ALL
SELECT DISTINCT SUBSTRING(CASE WHEN CHARINDEX('MOTOCICLETA',f120_descripcion) > 0 THEN
                                    REPLACE(f120_descripcion, 'MOTOCICLETA ', '')
                               WHEN CHARINDEX('MOTO',f120_descripcion) > 0 THEN
                                    REPLACE(f120_descripcion, 'MOTO ', '')
                               ELSE TRIM(f120_descripcion)
                          END
				 + ' ' + REPLACE(f417_campo_5, char(13) + char(10), '')
				 + ' ' + REPLACE(f117_descripcion, char(13) + char(10), ''),1,40) mmcm16,
       'MOT_LINEA' caracteristica,
       (SELECT hmlg.hmlg_codigosap
          FROM vw_homologacionessap hmlg
         WHERE hmlg.legacy = 'UNOEE'
           AND hmlg.parm_tipohomologacion = 43
           AND hmlg.hmlg_codigolegacy = TRIM(prime.f_criterio_item_prime (t120.f120_id_cia,t120.f120_rowid,'107'))) valor      -- Homologacion
  FROM UNOEE_FANALCA.dbo.t417_cm_seriales t417
 INNER JOIN UNOEE_FANALCA.dbo.t121_mc_items_extensiones t121 ON t417.f417_id_cia = t121.f121_id_cia
       AND t417.f417_rowid_item_ext = t121.f121_rowid
 INNER JOIN UNOEE_FANALCA.dbo.t120_mc_items t120 ON t120.f120_rowid = t121.f121_rowid_item
 INNER JOIN UNOEE_FANALCA.dbo.t117_mc_extensiones1_detalle t117 ON t117.f117_id_cia = t121.f121_id_cia
       AND t117.f117_id = t121.f121_id_ext1_detalle
 WHERE t417.f417_id_cia = 1
   AND t417.f417_id_cfg_serial IN ('01','02','03','04','JA739','KF579','NC609') -- Filtro serial materiales
   AND t417.f417_campo_1 IS NOT NULL
   AND t417.f417_campo_5 IS NOT NULL
   AND t120.f120_ind_venta = 1
   AND ( (TRIM(SUBSTRING(CASE WHEN CHARINDEX('MOTOCICLETA',f120_descripcion) > 0 THEN
                                   REPLACE(f120_descripcion,'MOTOCICLETA ','')
                              WHEN CHARINDEX('MOTO',f120_descripcion) > 0 THEN
                                   REPLACE(f120_descripcion, 'MOTO ', '')
                              ELSE TRIM(f120_descripcion)
                         END
				 + ' ' + REPLACE(f417_campo_5, char(13) + char(10), '')
				 + ' ' + REPLACE(f117_descripcion, char(13) + char(10), ''),1,40)
              )
		 ) IN (SELECT TRIM(intf_item)
                 FROM detalleinterfaz deti, interfaces inter
                WHERE deti.intf_consecutivo = inter.intf_consecutivo
                  AND inter.intf_consecutivo = (SELECT vhpg_valor
                                                  FROM vlrsprmgrales
                                                 WHERE pmgr_parametro = 'MMMAEMT_CONSINT')
                  AND deti.parm_interfaz = (SELECT intf.parm_consecutivo
                                              FROM ge_tparametros intf
                                             INNER JOIN ge_tparametros modu ON modu.parm_consecutivo = intf.parm_padre
                                             INNER JOIN ge_tclasesparametros clap ON clap.clap_clase = modu.clap_clase
                                                   AND clap.clap_nombre = 'SAPMODULOSERP'
                                             WHERE modu.parm_descripcion = 'MM'
                                               AND intf.parm_codigo = 2)
		      )
        AND CONVERT(date,t120.f120_fecha_creacion) IN 
		    (SELECT CONVERT(date,deti_fechamov)
               FROM detalleinterfaz deti, interfaces inter
              WHERE deti.intf_consecutivo = inter.intf_consecutivo
                AND inter.intf_consecutivo = (SELECT vhpg_valor
                                                FROM vlrsprmgrales
                                               WHERE pmgr_parametro = 'MMMAEMT_CONSINT')
                AND deti.parm_interfaz = (SELECT intf.parm_consecutivo
                                            FROM ge_tparametros intf
                                           INNER JOIN ge_tparametros modu ON modu.parm_consecutivo = intf.parm_padre
                                           INNER JOIN ge_tclasesparametros clap ON clap.clap_clase = modu.clap_clase
                                                 AND clap.clap_nombre = 'SAPMODULOSERP'
                                           WHERE modu.parm_descripcion = 'MM'
                                             AND intf.parm_codigo = 2)
		    )
       )
    OR ( (TRIM(SUBSTRING(CASE WHEN CHARINDEX('MOTOCICLETA',f120_descripcion) > 0 THEN
                                   REPLACE(f120_descripcion, 'MOTOCICLETA ', '')
                              WHEN CHARINDEX('MOTO',f120_descripcion) > 0 THEN
                                   REPLACE(f120_descripcion, 'MOTO ', '')
                              ELSE TRIM(f120_descripcion)
                         END
				 + ' ' + REPLACE(f417_campo_5, char(13) + char(10), '')
				 + ' ' + REPLACE(f117_descripcion, char(13) + char(10), ''),1,40)
              )
	     ) IN (SELECT TRIM(intf_item)
                 FROM detalleinterfaz deti, interfaces inter
                WHERE deti.intf_consecutivo = inter.intf_consecutivo
                  AND inter.intf_consecutivo = (SELECT vhpg_valor
                                                  FROM vlrsprmgrales
                                                 WHERE pmgr_parametro = 'MMMAEMT_CONSINT')
                  AND deti.parm_interfaz = (SELECT intf.parm_consecutivo
                                              FROM ge_tparametros intf
                                             INNER JOIN ge_tparametros modu ON modu.parm_consecutivo = intf.parm_padre
                                             INNER JOIN ge_tclasesparametros clap ON clap.clap_clase = modu.clap_clase
                                                   AND clap.clap_nombre = 'SAPMODULOSERP'
                                             WHERE modu.parm_descripcion = 'MM'
                                               AND intf.parm_codigo = 2)
              )
        AND (CONVERT(date,t120.f120_fecha_actualizacion)) IN 
		    (SELECT CONVERT(date,deti_fechamov)
               FROM detalleinterfaz deti, interfaces inter
              WHERE deti.intf_consecutivo = inter.intf_consecutivo
                AND inter.intf_consecutivo = (SELECT vhpg_valor
                                                FROM vlrsprmgrales
                                               WHERE pmgr_parametro = 'MMMAEMT_CONSINT')
                AND deti.parm_interfaz = (SELECT intf.parm_consecutivo
                                            FROM ge_tparametros intf
                                           INNER JOIN ge_tparametros modu ON modu.parm_consecutivo = intf.parm_padre
                                           INNER JOIN ge_tclasesparametros clap ON clap.clap_clase = modu.clap_clase
                                                 AND clap.clap_nombre = 'SAPMODULOSERP'
                                            WHERE modu.parm_descripcion = 'MM'
                                              AND intf.parm_codigo = 2)
            )
       )
UNION ALL
SELECT DISTINCT SUBSTRING(CASE WHEN CHARINDEX('MOTOCICLETA',f120_descripcion) > 0 THEN
	                                REPLACE(f120_descripcion, 'MOTOCICLETA ', '')
                               WHEN CHARINDEX('MOTO',f120_descripcion) > 0 THEN
                                    REPLACE(f120_descripcion, 'MOTO ', '')
                               ELSE TRIM (f120_descripcion)
                          END
				 + ' ' + REPLACE(f417_campo_5, char(13) + char(10), '')
				 + ' ' + REPLACE(f117_descripcion, char(13) + char(10), ''),1,40) mmcm16,
       'MOT_VERSION' caracteristica,
       (SELECT hmlg.hmlg_codigosap
          FROM vw_homologacionessap hmlg
         WHERE hmlg.legacy = 'UNOEE'
           AND hmlg.parm_tipohomologacion = 44
           AND hmlg.hmlg_codigolegacy = TRIM(prime.f_criterio_item_prime (t120.f120_id_cia,t120.f120_rowid,'107'))) valor    -- Homologacion
  FROM UNOEE_FANALCA.dbo.t417_cm_seriales t417
 INNER JOIN UNOEE_FANALCA.dbo.t121_mc_items_extensiones t121 ON t417.f417_id_cia = t121.f121_id_cia
       AND t417.f417_rowid_item_ext = t121.f121_rowid
 INNER JOIN UNOEE_FANALCA.dbo.t120_mc_items t120 ON t120.f120_rowid = t121.f121_rowid_item
 INNER JOIN UNOEE_FANALCA.dbo.t117_mc_extensiones1_detalle t117 ON t117.f117_id_cia = t121.f121_id_cia
   AND t117.f117_id = t121.f121_id_ext1_detalle
 WHERE t417.f417_id_cia = 1
   AND t417.f417_id_cfg_serial IN ('01','02','03','04','JA739','KF579','NC609') -- Filtro serial materiales
   AND t417.f417_campo_1 IS NOT NULL
   AND t417.f417_campo_5 IS NOT NULL
   AND t120.f120_ind_venta = 1
   AND ( (TRIM(SUBSTRING(CASE WHEN CHARINDEX('MOTOCICLETA',f120_descripcion) > 0 THEN
                                   REPLACE (f120_descripcion,'MOTOCICLETA ','')
                              WHEN CHARINDEX('MOTO',f120_descripcion) > 0 THEN
                                   REPLACE (f120_descripcion, 'MOTO ', '')
                              ELSE TRIM(f120_descripcion)
                         END
				 + ' ' + REPLACE(f417_campo_5, char(13) + char(10), '')
				 + ' ' + REPLACE(f117_descripcion, char(13) + char(10), ''),1,40)
	          )
	     ) IN (SELECT TRIM (intf_item)
                 FROM detalleinterfaz deti, interfaces inter
                WHERE deti.intf_consecutivo = inter.intf_consecutivo
                  AND inter.intf_consecutivo = (SELECT vhpg_valor
                                                  FROM vlrsprmgrales
                                                 WHERE pmgr_parametro = 'MMMAEMT_CONSINT')
                  AND deti.parm_interfaz = (SELECT intf.parm_consecutivo
                                              FROM ge_tparametros intf
                                             INNER JOIN ge_tparametros modu ON modu.parm_consecutivo = intf.parm_padre
                                             INNER JOIN ge_tclasesparametros clap ON clap.clap_clase = modu.clap_clase
                                                   AND clap.clap_nombre = 'SAPMODULOSERP'
                                             WHERE modu.parm_descripcion = 'MM'
                                               AND intf.parm_codigo = 2)
              )
        AND CONVERT(date,t120.f120_fecha_creacion) IN 
	        (SELECT CONVERT(date,deti_fechamov)
               FROM detalleinterfaz deti, interfaces inter
              WHERE deti.intf_consecutivo = inter.intf_consecutivo
                AND inter.intf_consecutivo = (SELECT vhpg_valor
                                                FROM vlrsprmgrales
                                               WHERE pmgr_parametro = 'MMMAEMT_CONSINT')
                AND deti.parm_interfaz = (SELECT intf.parm_consecutivo
                                            FROM ge_tparametros intf
                                           INNER JOIN ge_tparametros modu ON modu.parm_consecutivo = intf.parm_padre
                                           INNER JOIN ge_tclasesparametros clap ON clap.clap_clase = modu.clap_clase
                                                 AND clap.clap_nombre = 'SAPMODULOSERP'
                                           WHERE modu.parm_descripcion = 'MM'
                                             AND intf.parm_codigo = 2)
          
		    )
		)
    OR ( (TRIM(SUBSTRING(CASE WHEN CHARINDEX('MOTOCICLETA',f120_descripcion) > 0 THEN
                                   REPLACE(f120_descripcion, 'MOTOCICLETA ', '')
                              WHEN CHARINDEX('MOTO',f120_descripcion) > 0 THEN
                                   REPLACE(f120_descripcion, 'MOTO ', '')
                              ELSE TRIM(f120_descripcion)
                         END
				 + ' ' + REPLACE(f417_campo_5, char(13) + char(10), '')
				 + ' ' + REPLACE(f117_descripcion, char(13) + char(10), ''),1,40))
	     ) IN (SELECT TRIM(intf_item)
                 FROM detalleinterfaz deti, interfaces inter
                WHERE deti.intf_consecutivo = inter.intf_consecutivo
                  AND inter.intf_consecutivo = (SELECT vhpg_valor
					  		                      FROM vlrsprmgrales
                                                 WHERE pmgr_parametro = 'MMMAEMT_CONSINT')
                  AND deti.parm_interfaz = (SELECT intf.parm_consecutivo
                                              FROM ge_tparametros intf
					  					     INNER JOIN ge_tparametros modu ON modu.parm_consecutivo = intf.parm_padre
                                             INNER JOIN ge_tclasesparametros clap ON clap.clap_clase = modu.clap_clase
                                                   AND clap.clap_nombre = 'SAPMODULOSERP'
										     WHERE modu.parm_descripcion = 'MM'
                                               AND intf.parm_codigo = 2)
		      )
        AND CONVERT(date,t120.f120_fecha_actualizacion) IN 
		    (SELECT CONVERT(date,deti_fechamov)
               FROM detalleinterfaz deti, interfaces inter
              WHERE deti.intf_consecutivo = inter.intf_consecutivo
                AND inter.intf_consecutivo = (SELECT vhpg_valor
		 					                    FROM vlrsprmgrales
                                               WHERE pmgr_parametro = 'MMMAEMT_CONSINT')
                AND deti.parm_interfaz = (SELECT intf.parm_consecutivo
                                            FROM ge_tparametros intf
				 						   INNER JOIN ge_tparametros modu ON modu.parm_consecutivo = intf.parm_padre
                                           INNER JOIN ge_tclasesparametros clap ON clap.clap_clase = modu.clap_clase
                                                 AND clap.clap_nombre = 'SAPMODULOSERP'
										   WHERE modu.parm_descripcion = 'MM'
                                             AND intf.parm_codigo = 2)
		    )
	   )
UNION ALL
SELECT DISTINCT SUBSTRING(CASE WHEN CHARINDEX('MOTOCICLETA',f120_descripcion) > 0 THEN
                                    REPLACE(f120_descripcion, 'MOTOCICLETA ', '')
                               WHEN CHARINDEX('MOTO',f120_descripcion) > 0 THEN
                                    REPLACE(f120_descripcion, 'MOTO ', '')
                               ELSE TRIM(f120_descripcion)
                          END
				 + ' ' + REPLACE(f417_campo_5, char(13) + char(10), '')
				 + ' ' + REPLACE(f117_descripcion, char(13) + char(10), ''),1,40) mmcm16,
       'MOT_MODELO' caracteristica,
       t417.f417_campo_5 valor
  FROM UNOEE_FANALCA.dbo.t417_cm_seriales t417
 INNER JOIN UNOEE_FANALCA.dbo.t121_mc_items_extensiones t121 ON t417.f417_id_cia = t121.f121_id_cia
       AND t417.f417_rowid_item_ext = t121.f121_rowid
 INNER JOIN UNOEE_FANALCA.dbo.t120_mc_items t120 ON t120.f120_rowid = t121.f121_rowid_item
 INNER JOIN UNOEE_FANALCA.dbo.t117_mc_extensiones1_detalle t117 ON t117.f117_id_cia = t121.f121_id_cia
       AND t117.f117_id = t121.f121_id_ext1_detalle
 WHERE t417.f417_id_cia = 1
   AND t417.f417_id_cfg_serial IN ('01','02','03','04','JA739','KF579','NC609') -- Filtro serial materiales
   AND t417.f417_campo_1 IS NOT NULL
   AND t417.f417_campo_5 IS NOT NULL
   AND t120.f120_ind_venta = 1
   AND ( (TRIM(SUBSTRING(CASE WHEN CHARINDEX('MOTOCICLETA',f120_descripcion) > 0 THEN
                                   REPLACE(f120_descripcion,'MOTOCICLETA ','')
                              WHEN CHARINDEX('MOTO',f120_descripcion) > 0 THEN
                                   REPLACE(f120_descripcion, 'MOTO ', '')
                              ELSE TRIM(f120_descripcion)
                         END
				 + ' ' + REPLACE(f417_campo_5, char(13) + char(10), '')
				 + ' ' + REPLACE(f117_descripcion, char(13) + char(10), ''),1,40)
              )
	     ) IN (SELECT TRIM(intf_item)
                 FROM detalleinterfaz deti, interfaces inter
                WHERE deti.intf_consecutivo = inter.intf_consecutivo
                  AND inter.intf_consecutivo = (SELECT vhpg_valor
                                                  FROM vlrsprmgrales
                                                 WHERE pmgr_parametro = 'MMMAEMT_CONSINT')
                  AND deti.parm_interfaz = (SELECT intf.parm_consecutivo
                                              FROM ge_tparametros intf
                                             INNER JOIN ge_tparametros modu ON modu.parm_consecutivo = intf.parm_padre
                                             INNER JOIN ge_tclasesparametros clap ON clap.clap_clase = modu.clap_clase
                                                   AND clap.clap_nombre = 'SAPMODULOSERP'
                                             WHERE modu.parm_descripcion = 'MM'
                                               AND intf.parm_codigo = 2)
              )
        AND CONVERT(date,t120.f120_fecha_creacion) IN 
            (SELECT CONVERT(date,deti_fechamov)
               FROM detalleinterfaz deti, interfaces inter
              WHERE deti.intf_consecutivo = inter.intf_consecutivo
                AND inter.intf_consecutivo = (SELECT vhpg_valor
                                                FROM vlrsprmgrales
                                               WHERE pmgr_parametro = 'MMMAEMT_CONSINT')
                AND deti.parm_interfaz = (SELECT intf.parm_consecutivo
                                            FROM ge_tparametros intf
                                           INNER JOIN ge_tparametros modu ON modu.parm_consecutivo = intf.parm_padre
                                           INNER JOIN ge_tclasesparametros clap ON clap.clap_clase = modu.clap_clase
                                                 AND clap.clap_nombre = 'SAPMODULOSERP'
                                           WHERE modu.parm_descripcion = 'MM'
                                             AND intf.parm_codigo = 2)
            )
	   )
    OR ( (TRIM(SUBSTRING(CASE WHEN CHARINDEX('MOTOCICLETA',f120_descripcion) > 0 THEN
                                   REPLACE(f120_descripcion, 'MOTOCICLETA ', '')
                              WHEN CHARINDEX('MOTO',f120_descripcion) > 0 THEN
                                   REPLACE(f120_descripcion, 'MOTO ', '')
                              ELSE TRIM (f120_descripcion)
                         END
				 + ' ' + REPLACE(f417_campo_5, char(13) + char(10), '')
				 + ' ' + REPLACE(f117_descripcion, char(13) + char(10), ''),1,40)
			  )
		 ) IN (SELECT TRIM(intf_item)
                 FROM detalleinterfaz deti, interfaces inter
                WHERE deti.intf_consecutivo = inter.intf_consecutivo
                  AND inter.intf_consecutivo = (SELECT vhpg_valor
                                                  FROM vlrsprmgrales
                                                 WHERE pmgr_parametro = 'MMMAEMT_CONSINT')
                  AND deti.parm_interfaz = (SELECT intf.parm_consecutivo
                                              FROM ge_tparametros intf
                                             INNER JOIN ge_tparametros modu ON modu.parm_consecutivo = intf.parm_padre
                                             INNER JOIN ge_tclasesparametros clap ON clap.clap_clase = modu.clap_clase
                                                   AND clap.clap_nombre = 'SAPMODULOSERP'
                                             WHERE modu.parm_descripcion = 'MM'
                                               AND intf.parm_codigo = 2)
			  )

        AND CONVERT(date,t120.f120_fecha_actualizacion) IN 
		    (SELECT CONVERT(date,deti_fechamov)
               FROM detalleinterfaz deti, interfaces inter
              WHERE deti.intf_consecutivo = inter.intf_consecutivo
                AND inter.intf_consecutivo = (SELECT vhpg_valor
                                                FROM vlrsprmgrales
                                                WHERE pmgr_parametro = 'MMMAEMT_CONSINT')
                AND deti.parm_interfaz = (SELECT intf.parm_consecutivo
                                            FROM ge_tparametros intf
                                           INNER JOIN ge_tparametros modu ON modu.parm_consecutivo = intf.parm_padre
                                           INNER JOIN ge_tclasesparametros clap ON clap.clap_clase = modu.clap_clase
                                                 AND clap.clap_nombre = 'SAPMODULOSERP'
                                           WHERE modu.parm_descripcion = 'MM'
                                             AND intf.parm_codigo = 2)
			)
       )
UNION ALL
SELECT DISTINCT SUBSTRING(CASE WHEN CHARINDEX('MOTOCICLETA',f120_descripcion) > 0 THEN
                                    REPLACE(f120_descripcion, 'MOTOCICLETA ', '')
                               WHEN CHARINDEX('MOTO',f120_descripcion) > 0 THEN
                                    REPLACE(f120_descripcion, 'MOTO ', '')
                               ELSE TRIM(f120_descripcion)
                          END
				 + ' ' + REPLACE(f417_campo_5, char(13) + char(10), '')
				 + ' ' + REPLACE(f117_descripcion, char(13) + char(10), ''),1,40) mmcm16,
       'MOT_CILINDRAJE' caracteristica,
       (SELECT hmlg.hmlg_codigosap
          FROM vw_homologacionessap hmlg
         WHERE hmlg.legacy = 'UNOEE'
           AND hmlg.parm_tipohomologacion = 49
           AND hmlg.hmlg_codigolegacy = TRIM(prime.f_criterio_item_prime (t120.f120_id_cia,t120.f120_rowid,'500'))) valor        -- Homologacion
  FROM UNOEE_FANALCA.dbo.t417_cm_seriales t417
 INNER JOIN UNOEE_FANALCA.dbo.t121_mc_items_extensiones t121 ON t417.f417_id_cia = t121.f121_id_cia
       AND t417.f417_rowid_item_ext = t121.f121_rowid
 INNER JOIN UNOEE_FANALCA.dbo.t120_mc_items t120 ON t120.f120_rowid = t121.f121_rowid_item
 INNER JOIN UNOEE_FANALCA.dbo.t117_mc_extensiones1_detalle t117 ON t117.f117_id_cia = t121.f121_id_cia
       AND t117.f117_id = t121.f121_id_ext1_detalle
 WHERE t417.f417_id_cia = 1
   AND t417.f417_id_cfg_serial IN ('01','02','03','04','JA739','KF579','NC609') -- Filtro serial materiales
   AND t417.f417_campo_1 IS NOT NULL
   AND t417.f417_campo_5 IS NOT NULL
   AND t120.f120_ind_venta = 1
   AND ( (TRIM(SUBSTRING(CASE WHEN CHARINDEX('MOTOCICLETA',f120_descripcion) > 0 THEN
                                   REPLACE(f120_descripcion,'MOTOCICLETA ','')
                              WHEN CHARINDEX('MOTO',f120_descripcion) > 0 THEN
                                   REPLACE(f120_descripcion, 'MOTO ', '')
                              ELSE TRIM(f120_descripcion)
                         END
				 + ' ' + REPLACE(f417_campo_5, char(13) + char(10), '')
				 + ' ' + REPLACE(f117_descripcion, char(13) + char(10), ''),1,40)
              )
		 ) IN (SELECT TRIM(intf_item)
                 FROM detalleinterfaz deti, interfaces inter
                WHERE deti.intf_consecutivo = inter.intf_consecutivo
                  AND inter.intf_consecutivo = (SELECT vhpg_valor
                                                  FROM vlrsprmgrales
                                                 WHERE pmgr_parametro = 'MMMAEMT_CONSINT')
                  AND deti.parm_interfaz = (SELECT intf.parm_consecutivo
                                              FROM ge_tparametros intf
                                             INNER JOIN ge_tparametros modu ON modu.parm_consecutivo = intf.parm_padre
                                             INNER JOIN ge_tclasesparametros clap ON clap.clap_clase = modu.clap_clase
                                                   AND clap.clap_nombre = 'SAPMODULOSERP'
                                              WHERE modu.parm_descripcion = 'MM'
                                                AND intf.parm_codigo = 2)
              )
        AND CONVERT(date,t120.f120_fecha_creacion) IN 
		    (SELECT CONVERT(date,deti_fechamov)
                 FROM detalleinterfaz deti, interfaces inter
                WHERE deti.intf_consecutivo = inter.intf_consecutivo
                  AND inter.intf_consecutivo = (SELECT vhpg_valor
                                                  FROM vlrsprmgrales
                                                 WHERE pmgr_parametro = 'MMMAEMT_CONSINT')
                  AND deti.parm_interfaz = (SELECT intf.parm_consecutivo
                                              FROM ge_tparametros intf
                                             INNER JOIN ge_tparametros modu ON modu.parm_consecutivo = intf.parm_padre
                                             INNER JOIN ge_tclasesparametros clap ON clap.clap_clase = modu.clap_clase
                                                   AND clap.clap_nombre = 'SAPMODULOSERP'
                                              WHERE modu.parm_descripcion = 'MM'
                                                AND intf.parm_codigo = 2)
              )
       )
    OR ( (TRIM(SUBSTRING(CASE WHEN CHARINDEX('MOTOCICLETA',f120_descripcion) > 0 THEN
                                   REPLACE(f120_descripcion, 'MOTOCICLETA ', '')
                              WHEN CHARINDEX('MOTO',f120_descripcion) > 0 THEN
                                   REPLACE(f120_descripcion, 'MOTO ', '')
                              ELSE TRIM(f120_descripcion)
                         END
				 + ' ' + REPLACE(f417_campo_5, char(13) + char(10), '')
				 + ' ' + REPLACE(f117_descripcion, char(13) + char(10), ''),1,40)
			  )
         ) IN (SELECT TRIM(intf_item)
                 FROM detalleinterfaz deti, interfaces inter
                WHERE deti.intf_consecutivo = inter.intf_consecutivo
                  AND inter.intf_consecutivo = (SELECT vhpg_valor
                                                  FROM vlrsprmgrales
                                                 WHERE pmgr_parametro = 'MMMAEMT_CONSINT')
                  AND deti.parm_interfaz = (SELECT intf.parm_consecutivo
                                              FROM ge_tparametros intf
                                             INNER JOIN ge_tparametros modu ON modu.parm_consecutivo = intf.parm_padre
                                             INNER JOIN ge_tclasesparametros clap ON clap.clap_clase = modu.clap_clase
                                                   AND clap.clap_nombre = 'SAPMODULOSERP'
                                             WHERE modu.parm_descripcion = 'MM'
                                               AND intf.parm_codigo = 2)
              )
        AND CONVERT(date,t120.f120_fecha_actualizacion) IN 
		   (SELECT CONVERT(date,deti_fechamov)
              FROM detalleinterfaz deti, interfaces inter
             WHERE deti.intf_consecutivo = inter.intf_consecutivo
               AND inter.intf_consecutivo = (SELECT vhpg_valor
                                               FROM vlrsprmgrales
                                               WHERE pmgr_parametro = 'MMMAEMT_CONSINT')
               AND deti.parm_interfaz = (SELECT intf.parm_consecutivo
                                           FROM ge_tparametros intf
                                          INNER JOIN ge_tparametros modu ON modu.parm_consecutivo = intf.parm_padre
                                          INNER JOIN ge_tclasesparametros clap ON clap.clap_clase = modu.clap_clase
                                                AND clap.clap_nombre = 'SAPMODULOSERP'
                                          WHERE modu.parm_descripcion = 'MM'
                                            AND intf.parm_codigo = 2)
           )
       )
UNION ALL
SELECT DISTINCT SUBSTRING(CASE WHEN CHARINDEX('MOTOCICLETA',f120_descripcion) > 0 THEN
                                    REPLACE(f120_descripcion, 'MOTOCICLETA ', '') 
                               WHEN CHARINDEX('MOTO',f120_descripcion) > 0 THEN
                                    REPLACE(f120_descripcion, 'MOTO ', '')
                               ELSE TRIM(f120_descripcion)
                          END
				 + ' ' + REPLACE(f417_campo_5, char(13) + char(10), '')
				 + ' ' + REPLACE(f117_descripcion, char(13) + char(10), ''),1,40) mmcm16,
       'MOT_COLOR' caracteristica,
       (SELECT hmlg.hmlg_codigosap
          FROM vw_homologacionessap hmlg
         WHERE hmlg.legacy = 'UNOEE'
           AND hmlg.parm_tipohomologacion = 48
           AND hmlg.hmlg_codigolegacy = TRIM(t121.f121_id_ext1_detalle)) valor         -- Homologacion
  FROM UNOEE_FANALCA.dbo.t417_cm_seriales t417
 INNER JOIN UNOEE_FANALCA.dbo.t121_mc_items_extensiones t121 ON t417.f417_id_cia = t121.f121_id_cia
       AND t417.f417_rowid_item_ext = t121.f121_rowid
 INNER JOIN UNOEE_FANALCA.dbo.t120_mc_items t120 ON t120.f120_rowid = t121.f121_rowid_item
 INNER JOIN UNOEE_FANALCA.dbo.t117_mc_extensiones1_detalle t117 ON t117.f117_id_cia = t121.f121_id_cia
       AND t117.f117_id = t121.f121_id_ext1_detalle
 WHERE t417.f417_id_cia = 1
   AND t417.f417_id_cfg_serial IN ('01','02','03','04','JA739','KF579','NC609') -- Filtro serial materiales
   AND t417.f417_campo_1 IS NOT NULL
   AND t417.f417_campo_5 IS NOT NULL
   AND t120.f120_ind_venta = 1
   AND ( (TRIM(SUBSTRING(CASE WHEN CHARINDEX('MOTOCICLETA',f120_descripcion) > 0 THEN
                                   REPLACE(f120_descripcion,'MOTOCICLETA ','')
                              WHEN CHARINDEX('MOTO',f120_descripcion) > 0 THEN
                                   REPLACE(f120_descripcion, 'MOTO ', '')
                              ELSE TRIM(f120_descripcion)
                         END
				 + ' ' + REPLACE(f417_campo_5, char(13) + char(10), '')
				 + ' ' + REPLACE(f117_descripcion, char(13) + char(10), ''),1,40)
              )
         ) IN (SELECT TRIM(intf_item)
                 FROM detalleinterfaz deti, interfaces inter
                WHERE deti.intf_consecutivo = inter.intf_consecutivo
                  AND inter.intf_consecutivo = (SELECT vhpg_valor
                                                  FROM vlrsprmgrales
                                                 WHERE pmgr_parametro = 'MMMAEMT_CONSINT')
                  AND deti.parm_interfaz = (SELECT intf.parm_consecutivo
                                              FROM ge_tparametros intf
                                             INNER JOIN ge_tparametros modu ON modu.parm_consecutivo = intf.parm_padre
                                             INNER JOIN ge_tclasesparametros clap ON clap.clap_clase = modu.clap_clase
                                                   AND clap.clap_nombre = 'SAPMODULOSERP'
                                             WHERE modu.parm_descripcion = 'MM'
                                               AND intf.parm_codigo = 2)
              )
        AND CONVERT(date,t120.f120_fecha_creacion) IN 
		    (SELECT CONVERT(date,deti_fechamov)
               FROM detalleinterfaz deti, interfaces inter
              WHERE deti.intf_consecutivo = inter.intf_consecutivo
                AND inter.intf_consecutivo = (SELECT vhpg_valor
                                                FROM vlrsprmgrales
                                               WHERE pmgr_parametro = 'MMMAEMT_CONSINT')
                AND deti.parm_interfaz = (SELECT intf.parm_consecutivo
                                            FROM ge_tparametros intf
                                           INNER JOIN ge_tparametros modu ON modu.parm_consecutivo = intf.parm_padre
                                           INNER JOIN ge_tclasesparametros clap ON clap.clap_clase = modu.clap_clase
                                                 AND clap.clap_nombre = 'SAPMODULOSERP'
                                           WHERE modu.parm_descripcion = 'MM'
                                             AND intf.parm_codigo = 2)
            )
       )
    OR ( (TRIM(SUBSTRING(CASE WHEN CHARINDEX('MOTOCICLETA',f120_descripcion) > 0 THEN
                                   REPLACE(f120_descripcion, 'MOTOCICLETA ', '')
                              WHEN CHARINDEX('MOTO',f120_descripcion) > 0 THEN
                                   REPLACE(f120_descripcion, 'MOTO ', '')
                              ELSE TRIM(f120_descripcion)
                         END
				 + ' ' + REPLACE(f417_campo_5, char(13) + char(10), '')
				 + ' ' + REPLACE(f117_descripcion, char(13) + char(10), ''),1,40)
              )
         ) IN (SELECT TRIM (intf_item)
                 FROM detalleinterfaz deti, interfaces inter
                WHERE deti.intf_consecutivo = inter.intf_consecutivo
                  AND inter.intf_consecutivo = (SELECT vhpg_valor
                                                  FROM vlrsprmgrales
                                                 WHERE pmgr_parametro = 'MMMAEMT_CONSINT')
                  AND deti.parm_interfaz = (SELECT intf.parm_consecutivo
                                              FROM ge_tparametros intf
                                             INNER JOIN ge_tparametros modu ON modu.parm_consecutivo = intf.parm_padre
                                             INNER JOIN ge_tclasesparametros clap ON clap.clap_clase = modu.clap_clase
                                                   AND clap.clap_nombre = 'SAPMODULOSERP'
                                             WHERE modu.parm_descripcion = 'MM'
                                               AND intf.parm_codigo = 2)
              )
        AND CONVERT(date,t120.f120_fecha_actualizacion) IN 
		    (SELECT CONVERT(date,deti_fechamov)
               FROM detalleinterfaz deti, interfaces inter
              WHERE deti.intf_consecutivo = inter.intf_consecutivo
                AND inter.intf_consecutivo = (SELECT vhpg_valor
                                                FROM vlrsprmgrales
                                               WHERE pmgr_parametro = 'MMMAEMT_CONSINT')
                AND deti.parm_interfaz = (SELECT intf.parm_consecutivo
                                            FROM ge_tparametros intf
                                           INNER JOIN ge_tparametros modu ON modu.parm_consecutivo = intf.parm_padre
                                           INNER JOIN ge_tclasesparametros clap ON clap.clap_clase = modu.clap_clase
                                                 AND clap.clap_nombre = 'SAPMODULOSERP'
                                           WHERE modu.parm_descripcion = 'MM'
                                             AND intf.parm_codigo = 2)
            )
       );
GO


