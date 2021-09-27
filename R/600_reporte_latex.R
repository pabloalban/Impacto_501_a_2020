# Parámetros y carga -------------------------------------------------------------------------------
source( 'R/002_cargar_paquetes.R', encoding = 'UTF-8', echo = FALSE )
source( 'R/003_configurar_proyecto.R', encoding = 'UTF-8', echo = FALSE )

# Preparación---------------------------------------------------------------------------------------
source( 'R/400_preparar_reporte.R', encoding = 'UTF-8', echo = FALSE )


# Gráficos------------------------------------------------------------------------------------------
source( 'R/402_graf_tasas_aporte.R', encoding = 'UTF-8', echo = FALSE )


#Tablas---------------------------------------------------------------------------------------------
source( 'R/500_tab_tasas_aporte.R', encoding = 'UTF-8', echo = FALSE )
source( 'R/501_tab_aportes.R', encoding = 'UTF-8', echo = FALSE )


#Calculo de balances actuariales--------------------------------------------------------------------


# Reporte LaTeX
source( parametros$reporte_script, encoding = 'UTF-8', echo = FALSE )
