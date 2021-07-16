# Datos para gráfico de Tabla 2 del documento "causas de posible desfinanciamiento".
# Tabla 2: Comparación de las primas de aportes: Resolución C.D. 501 – Resolución C.D. 261.

# Carga de datos -----------------------------------------------------------------------------------
message( '\tGráfica de cooparación entre primas de la CD501 y CD261' )
file_prima <- paste0( parametros$RData_seg, 'IESS_RTR_causas_desfinanciamiento.RData' )
load( file = file_prima )
Comparacion_Primas <- (comparacion_primas)
setnames(Comparacion_Primas, c("Año", "C.D.501", "C.D.261", "Etiqueta"))
com_pri_apo <- Comparacion_Primas
com_pri_apo$Año <- as.character(com_pri_apo$Año)
com_pri_apo$Año <- ymd(paste0(com_pri_apo$Año, '/01/01'))
com_pri_apo$Año <- as.Date(com_pri_apo$Año,"%Y-%m-%d")
com_pri_apo$C.D.501 <- com_pri_apo$C.D.501/100
com_pri_apo$C.D.261 <- com_pri_apo$C.D.261/100
com_pri_apo['C.D.501_privados'] <- com_pri_apo$C.D.501
com_pri_apo['C.D.501_publicos'] <- com_pri_apo$C.D.501
com_pri_apo$C.D.501_publicos[c(10:11)] <- c(0.0038,0.0038)

message( paste( rep('-', 100 ), collapse = '' ) )
message( '\tGrafico: Comparación de las primas de aportes' )

source( 'R/401_graf_plantilla.R', encoding = 'UTF-8', echo = FALSE )

#Gráfico de comparación de tasas de aportación------------------------------------------------------
x_lim <- c( 2012, 2022 )
x_brk <- seq( x_lim[1], x_lim[2], 1 )
y_brk<- seq(0.001,0.006,0.0005)
y_lbl <- paste0(formatC(100 * y_brk, digits = 2, format = 'f', big.mark = '.', decimal.mark = ',' ),"%")

plt_com_pri_apo <-  ggplot(com_pri_apo, aes(Año)) + 
                    geom_line(aes(y = C.D.261,colour ="C.D.261")) +
                    geom_line(aes(y = C.D.501_privados,colour ="C.D.501 privados"), size=1.5) +
                    geom_line(aes(y = C.D.501_publicos,colour ="C.D.501 públicos"),
                              linetype = "dashed",
                              alpha=0.8,
                              size=1.1) +
                    geom_point(aes(y = C.D.501_privados,colour ="C.D.501 privados"), 
                               shape = 15, 
                               # size = graf_line_size,
                               size = 3,
                               color = parametros$iess_green)+
                    geom_point(aes(y = C.D.501_publicos,colour ="C.D.501 públicos"), 
                               shape = 20, 
                               # size = graf_line_size,
                               size = 3,
                               color = 'red' ) +
                    geom_point( aes(y = C.D.261,colour ="C.D.261"), 
                                shape = 15, 
                                # size = graf_line_size,
                                size = 2,
                                color = parametros$iess_blue ) +
                    scale_x_date(date_breaks = "1 year", date_labels = "%Y")+
                    scale_y_continuous(breaks = y_brk,
                                       labels = y_lbl,
                                       limits = c(y_brk[1], max(y_brk))) +
                    scale_colour_manual("", 
                                        breaks = c("C.D.501 privados", "C.D.501 públicos" ,"C.D.261"), 
                                        values = c("C.D.501 privados" = parametros$iess_green ,
                                                   "C.D.501 públicos" = 'red',
                                                   "C.D.261" = parametros$iess_blue))+
                    # geom_text_repel(aes(Año, C.D.501, label =Etiqueta ),
                    #                 point.padding = unit(0.19, 'lines'),
                    #                 arrow = arrow(length = unit(0.01, 'npc')),
                    #                 segment.size = 0.1,
                    #                 segment.color = '#cccccc'
                    # ) +
                    theme_bw() +
                    plt_theme +
                    theme(legend.position="bottom") +
                    labs( x = '', y = '' )+
                    theme( axis.text.x = element_text(angle = 90, hjust = 1 ) )


#Guaradando gráfica en formato png------------------------------------------------------------------
ggsave( plot = plt_com_pri_apo, 
        filename = paste0( parametros$resultado_graficos, 'iess_grafico_tasas_aporte', parametros$graf_ext ),
        width = graf_width, height = graf_height, units = graf_units, dpi = graf_dpi )

message( paste( rep('-', 100 ), collapse = '' ) )
rm( list = ls()[ !( ls() %in% c( 'parametros' ) ) ] )
gc()