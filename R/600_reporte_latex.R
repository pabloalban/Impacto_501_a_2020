# Parámetros y carga -------------------------------------------------------------------------------
source( 'R/002_cargar_paquetes.R', encoding = 'UTF-8', echo = FALSE )
source( 'R/003_configurar_proyecto.R', encoding = 'UTF-8', echo = FALSE )

# Preparación---------------------------------------------------------------------------------------
source( 'R/400_preparar_reporte.R', encoding = 'UTF-8', echo = FALSE )

#Calculo de balances actuariales--------------------------------------------------------------------

#Balances de RTR------------------------------------------------------------------------------------
source( 'R/305_calculo_escenarios_balance_rtr.R', encoding = 'UTF-8', echo = FALSE )

#Tablas de RTR--------------------------------------------------------------------------------------
source( 'R/505_tab_balance_rtr.R', encoding = 'UTF-8', echo = FALSE )
source( 'R/510_tab_resumen_resultados_rtr.R', encoding = 'UTF-8', echo = FALSE )

#Gráficas de RTR------------------------------------------------------------------------------------
source( 'R/403_graf_comp_primas_rtr.R', encoding = 'UTF-8', echo = FALSE )
source( 'R/404_graf_balance_actuarial_rtr.R', encoding = 'UTF-8', echo = FALSE )

#Balances de IVM------------------------------------------------------------------------------------
source( 'R/303_calculo_escenarios_balance_ivm.R', encoding = 'UTF-8', echo = FALSE )
#Tablas de IVM--------------------------------------------------------------------------------------
source( 'R/502_tab_balance_ivm.R', encoding = 'UTF-8', echo = FALSE )

#Gráficas de IVM------------------------------------------------------------------------------------
source( 'R/403_graf_balance_actuarial_ivm.R', encoding = 'UTF-8', echo = FALSE )

#Balances de Salud----------------------------------------------------------------------------------
source( 'R/302_calculo_escenarios_balance_sal.R', encoding = 'UTF-8', echo = FALSE )

#Tablas de Salud------------------------------------------------------------------------------------
source( 'R/502_tab_balance_sal.R', encoding = 'UTF-8', echo = FALSE )

#Gráficas de Salud----------------------------------------------------------------------------------
source( 'R/403_graf_balance_actuarial_sal.R', encoding = 'UTF-8', echo = FALSE )

# Reporte LaTeX
source( parametros$reporte_script, encoding = 'UTF-8', echo = FALSE )
