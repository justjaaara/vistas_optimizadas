CREATE VIEW [prime].[VW_MMCARRMT_DATOSINTERFAZ_NUEVA] AS
 
-- Project : PRIME Integraciones 1E - SAP ECC
-- Purpose : Caracteristicas Repuestos motos 1E - MM
-- Author  : TELLA Consulting
-- Created : 06/10/2025
-- Aplica  : 1E
-- Optimizado: Eliminación de subconsultas correlacionadas repetidas

WITH ItemDescripciones AS (
    -- Precalcular las descripciones concatenadas UNA SOLA VEZ por item
    SELECT 
        t120.f120_id_cia,
        t120.f120_rowid,
        t120.f120_referencia,
        t120.f120_fecha_creacion,
        t120.f120_fecha_actualizacion,
        t121.f121_id_cia,
        t121.f121_rowid_item,
        t121.f121_id_extension1,
        t121.f121_id_ext1_detalle,
        t121.f121_id_extension2,
        SUBSTRING(
            CONCAT(
                TRIM(t120.f120_referencia),
                ' ',
                TRIM(t116.f116_descripcion_corta),
                ' ',
                TRIM(t117.f117_descripcion_corta),
                ' ',
                TRIM(t118.f118_descripcion_corta),
                ' ',
                t121.f121_id_ext2_detalle
            ), 1, 40
        ) AS mmcm16
    FROM UNOEE_FANALCA.dbo.t120_mc_items t120
    INNER JOIN UNOEE_FANALCA.dbo.t121_mc_items_extensiones t121 
        ON t120.f120_id_cia = t121.f121_id_cia
        AND t120.f120_rowid = t121.f121_rowid_item
    INNER JOIN UNOEE_FANALCA.dbo.t116_mc_extensiones1 t116
        ON t116.f116_id_cia = t120.f120_id_cia
        AND t116.f116_id = t120.f120_id_extension1
    INNER JOIN UNOEE_FANALCA.dbo.t117_mc_extensiones1_detalle t117
        ON t117.f117_id_cia = t121.f121_id_cia
        AND t117.f117_id = t121.f121_id_ext1_detalle
        AND t117.f117_id_extension1 = t121.f121_id_extension1
        AND t116.f116_id_cia = t117.f117_id_cia
    INNER JOIN UNOEE_FANALCA.dbo.t118_mc_extensiones2 t118
        ON t118.f118_id_cia = t116.f116_id_cia
        AND t118.f118_id = t121.f121_id_extension2
    WHERE t120.f120_id_cia = 1
),
ParametrosCache AS (
    -- Precalcular los parámetros que se usan múltiples veces
    SELECT 
        vhpg.vhpg_valor AS consecutivo_interfaz
    FROM vlrsprmgrales vhpg
    WHERE vhpg.pmgr_parametro = 'MMMAEMT_CONSINT'
      AND vhpg.vhpg_estado = 1
),
DetalleInterfazFiltrado AS (
    -- Filtrar detalleinterfaz una sola vez con los parámetros
    SELECT DISTINCT
        TRIM(deti.intf_item) AS intf_item,
        deti.deti_fechamov
    FROM detalleinterfaz deti
    INNER JOIN ge_tparametros intf 
        ON intf.parm_consecutivo = deti.parm_interfaz
    INNER JOIN ge_tparametros modu 
        ON modu.parm_consecutivo = intf.parm_padre
    CROSS JOIN ParametrosCache pc
    WHERE deti.intf_consecutivo = pc.consecutivo_interfaz
      AND intf.parm_codigo = 2
      AND modu.parm_descripcion = 'MM'
)
-- Primera parte: REP_MOD_APLICABLES
SELECT 
    id.mmcm16,
    'REP_MOD_APLICABLES' AS caracteristica,
    prime.f_criterio_item(id.f120_id_cia, id.f120_rowid, 'H20') AS valor
FROM ItemDescripciones id
INNER JOIN DetalleInterfazFiltrado dif
    ON dif.intf_item = id.mmcm16
    AND CONVERT(date, dif.deti_fechamov) IN (
        CONVERT(date, id.f120_fecha_creacion),
        CONVERT(date, id.f120_fecha_actualizacion)
    )
WHERE prime.f_criterio_item(id.f120_id_cia, id.f120_rowid, 'H20') <> 'NO ESPECIFICADO'

UNION ALL

-- Segunda parte: REP_REF_EQUIVALENTES
SELECT 
    id.mmcm16,
    'REP_REF_EQUIVALENTES' AS caracteristica,
    t1201.f120_referencia AS valor
FROM ItemDescripciones id
INNER JOIN UNOEE_FANALCA.dbo.t128_mc_items_equivalentes t128 
    ON t128.f128_rowid_item = id.f120_rowid
INNER JOIN UNOEE_FANALCA.dbo.t120_mc_items t1201 
    ON t1201.f120_id_cia = t128.f128_id_cia
    AND t1201.f120_rowid = t128.f128_rowid_item_equivalente
INNER JOIN DetalleInterfazFiltrado dif
    ON dif.intf_item = id.mmcm16
    AND CONVERT(date, dif.deti_fechamov) IN (
        CONVERT(date, id.f120_fecha_creacion),
        CONVERT(date, id.f120_fecha_actualizacion)
    )
WHERE prime.f_criterio_item(id.f120_id_cia, id.f120_rowid, 'H20') <> 'NO ESPECIFICADO';

GO