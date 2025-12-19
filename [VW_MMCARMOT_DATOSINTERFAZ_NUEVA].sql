CREATE VIEW [prime].[VW_MMCARMOT_DATOSINTERFAZ_NUEVA] AS

-- Project : PRIME Integraciones 1E - SAP ECC
-- Purpose : Caracteristicas motos 1E - MM (OPTIMIZADA)
-- Author  : TELLA Consulting
-- Created : 06/10/2025
-- Optimized: 12/2025

-- CTE para construir el código de material una sola vez
WITH MaterialBase AS (
    SELECT DISTINCT
        t417.f417_id_cia,
        t417.f417_rowid_item_ext,
        t417.f417_campo_1,
        t417.f417_campo_5,
        t120.f120_rowid,
        t120.f120_id_cia,
        t120.f120_descripcion,
        t120.f120_fecha_creacion,
        t120.f120_fecha_actualizacion,
        t121.f121_id_ext1_detalle,
        t117.f117_descripcion,
        -- Calcular el código de material una sola vez
        SUBSTRING(
            CASE 
                WHEN CHARINDEX('MOTOCICLETA', t120.f120_descripcion) > 0 THEN
                    REPLACE(t120.f120_descripcion, 'MOTOCICLETA ', '')
                WHEN CHARINDEX('MOTO', t120.f120_descripcion) > 0 THEN
                    REPLACE(t120.f120_descripcion, 'MOTO ', '')
                ELSE TRIM(t120.f120_descripcion)
            END
            + ' ' + REPLACE(t417.f417_campo_5, CHAR(13) + CHAR(10), '')
            + ' ' + REPLACE(t117.f117_descripcion, CHAR(13) + CHAR(10), ''),
            1, 40
        ) AS codigo_material
    FROM UNOEE_FANALCA.dbo.t417_cm_seriales t417
    INNER JOIN UNOEE_FANALCA.dbo.t121_mc_items_extensiones t121 
        ON t417.f417_id_cia = t121.f121_id_cia
        AND t417.f417_rowid_item_ext = t121.f121_rowid
    INNER JOIN UNOEE_FANALCA.dbo.t120_mc_items t120 
        ON t120.f120_rowid = t121.f121_rowid_item
    INNER JOIN UNOEE_FANALCA.dbo.t117_mc_extensiones1_detalle t117 
        ON t117.f117_id_cia = t121.f121_id_cia
        AND t117.f117_id = t121.f121_id_ext1_detalle
    WHERE t417.f417_id_cia = 1
        AND t417.f417_id_cfg_serial IN ('01','02','03','04','JA739','KF579','NC609')
        AND t417.f417_campo_1 IS NOT NULL
        AND t417.f417_campo_5 IS NOT NULL
        AND t120.f120_ind_venta = 1
),
-- CTE para obtener la interfaz actual una sola vez
InterfazActual AS (
    SELECT 
        inter.intf_consecutivo,
        deti.parm_interfaz
    FROM interfaces inter
    CROSS APPLY (
        SELECT vhpg_valor 
        FROM vlrsprmgrales 
        WHERE pmgr_parametro = 'MMMAEMT_CONSINT'
    ) param
    CROSS APPLY (
        SELECT intf.parm_consecutivo
        FROM ge_tparametros intf
        INNER JOIN ge_tparametros modu 
            ON modu.parm_consecutivo = intf.parm_padre
        INNER JOIN ge_tclasesparametros clap 
            ON clap.clap_clase = modu.clap_clase
            AND clap.clap_nombre = 'SAPMODULOSERP'
        WHERE modu.parm_descripcion = 'MM'
            AND intf.parm_codigo = 2
    ) param_int
    INNER JOIN detalleinterfaz deti
        ON deti.intf_consecutivo = inter.intf_consecutivo
        AND deti.parm_interfaz = param_int.parm_consecutivo
    WHERE inter.intf_consecutivo = param.vhpg_valor
),
-- CTE para filtrar materiales válidos en la interfaz
MaterialesEnInterfaz AS (
    SELECT DISTINCT
        mb.codigo_material,
        mb.f120_rowid,
        mb.f120_id_cia,
        mb.f121_id_ext1_detalle,
        mb.f417_campo_5
    FROM MaterialBase mb
    INNER JOIN InterfazActual ia
        ON 1=1
    INNER JOIN detalleinterfaz deti
        ON deti.intf_consecutivo = ia.intf_consecutivo
        AND deti.parm_interfaz = ia.parm_interfaz
        AND TRIM(deti.intf_item) = TRIM(mb.codigo_material)
        AND (
            CONVERT(DATE, mb.f120_fecha_creacion) = CONVERT(DATE, deti.deti_fechamov)
            OR CONVERT(DATE, mb.f120_fecha_actualizacion) = CONVERT(DATE, deti.deti_fechamov)
        )
)
-- Generar las 6 características usando CROSS APPLY
SELECT DISTINCT
    mei.codigo_material AS mmcm16,
    caracteristicas.caracteristica,
    caracteristicas.valor
FROM MaterialesEnInterfaz mei
CROSS APPLY (
    -- MOT_MARCA
    SELECT 
        'MOT_MARCA' AS caracteristica,
        (SELECT hmlg.hmlg_codigosap
         FROM vw_homologacionessap hmlg
         WHERE hmlg.legacy = 'UNOEE'
             AND hmlg.parm_tipohomologacion = 42
             AND hmlg.hmlg_codigolegacy = TRIM(prime.f_criterio_item_prime(mei.f120_id_cia, mei.f120_rowid, '200'))
        ) AS valor
    
    UNION ALL
    
    -- MOT_LINEA
    SELECT 
        'MOT_LINEA',
        (SELECT hmlg.hmlg_codigosap
         FROM vw_homologacionessap hmlg
         WHERE hmlg.legacy = 'UNOEE'
             AND hmlg.parm_tipohomologacion = 43
             AND hmlg.hmlg_codigolegacy = TRIM(prime.f_criterio_item_prime(mei.f120_id_cia, mei.f120_rowid, '107'))
        )
    
    UNION ALL
    
    -- MOT_VERSION
    SELECT 
        'MOT_VERSION',
        (SELECT hmlg.hmlg_codigosap
         FROM vw_homologacionessap hmlg
         WHERE hmlg.legacy = 'UNOEE'
             AND hmlg.parm_tipohomologacion = 44
             AND hmlg.hmlg_codigolegacy = TRIM(prime.f_criterio_item_prime(mei.f120_id_cia, mei.f120_rowid, '107'))
        )
    
    UNION ALL
    
    -- MOT_MODELO
    SELECT 
        'MOT_MODELO',
        mei.f417_campo_5
    
    UNION ALL
    
    -- MOT_CILINDRAJE
    SELECT 
        'MOT_CILINDRAJE',
        (SELECT hmlg.hmlg_codigosap
         FROM vw_homologacionessap hmlg
         WHERE hmlg.legacy = 'UNOEE'
             AND hmlg.parm_tipohomologacion = 49
             AND hmlg.hmlg_codigolegacy = TRIM(prime.f_criterio_item_prime(mei.f120_id_cia, mei.f120_rowid, '500'))
        )
    
    UNION ALL
    
    -- MOT_COLOR
    SELECT 
        'MOT_COLOR',
        (SELECT hmlg.hmlg_codigosap
         FROM vw_homologacionessap hmlg
         WHERE hmlg.legacy = 'UNOEE'
             AND hmlg.parm_tipohomologacion = 48
             AND hmlg.hmlg_codigolegacy = TRIM(mei.f121_id_ext1_detalle)
        )
) caracteristicas
WHERE caracteristicas.valor IS NOT NULL;