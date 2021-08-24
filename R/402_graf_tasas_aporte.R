message( paste( rep('-', 100 ), collapse = '' ) )

# Plantilla gráfica --------------------------------------------------------------------------------
source( 'R/401_graf_plantilla.R', encoding = 'UTF-8', echo = FALSE )

# Carga de datos -----------------------------------------------------------------------------------
load( file = paste0( parametros$RData_seg, 'IESS_tasas_aportacion.Rdata' ) )
message( '\tGraficando las tasas de aportación' )

#Función para graficar------------------------------------------------------------------------------
plot_tasas_aporte <- function(file,s) {

  aux <- get(file) %>%
    filter( sector == s)
  
  iess_graf <- ggplot( data = aux ) + 
    geom_line( aes( x = fecha, 
                    y = cd_501, 
                    colour ="C.D.501" ), 
               size = graf_line_size,
               lineend = "round" ) + 
    geom_line( aes( x = fecha, 
                    y = cd_261, 
                    colour ="C.D.261" ), 
               size = graf_line_size,
               lineend = "round" ) + 
    scale_x_date(date_breaks = "1 year", date_labels = "%b-%Y")+
    scale_y_continuous(labels = scales::percent_format( accuracy = 1,
                                                        decimal.mark = ',' ),
                       #limits = c(0.05, 0.11),
                       breaks=pretty_breaks( n = 6 )
    ) +
    scale_colour_manual("", 
                        breaks = c("C.D.501", "C.D.261"), 
                        values = c("C.D.501" = parametros$iess_green , 
                                   "C.D.261" = parametros$iess_blue),
                        labels = c("Resolución No. C.D.501", 
                                   "Resolución No. C.D.261") ) +
    labs( x = '', y = paste0('Tasa aportación Sector ',s) ) +
    theme_bw() +
    plt_theme +
    theme(legend.position="bottom") +
    theme( axis.text.x = element_text(angle = 90, hjust = 1 ) )
 
    ggsave( plot = iess_graf, 
          filename = paste0( parametros$resultado_graficos,
                             'iess_tasa_', 
                             tolower(file), 
                             '_',
                             tolower(s),
                             parametros$graf_ext ),
          width = graf_width, height = graf_height, units = graf_units, dpi = graf_dpi )
  
return( iess_graf )  
}

#IVM------------------------------------------------------------------------------------------------
file <- "ivm_largo"
s <- 'Privado'
plot_tasas_aporte(file,s)
assign(paste0(tolower(file),'_',tolower(s)) ,plot_tasas_aporte(file,s))


file <- "ivm_largo"
s <- 'Privado'
plot_tasas_aporte(file,s)
assign(paste0(tolower(file),'_',tolower(s)) ,plot_tasas_aporte(file,s))



file <- "ivm_largo"
s <- 'Bancario'
plot_tasas_aporte(file,s)
assign(paste0(tolower(file),'_',tolower(s)) ,plot_tasas_aporte(file,s))



file <- "ivm_largo"
s <- 'Público'
plot_tasas_aporte(file,s)
assign(paste0(tolower(file),'_',tolower(s)) ,plot_tasas_aporte(file,s))



file <- "ivm_largo"
s <- 'Servicio exterior'
plot_tasas_aporte(file,s)
assign(paste0(tolower(file),'_',tolower(s)) ,plot_tasas_aporte(file,s))



file <- "ivm_largo"
s <- 'Industria azucarera'
plot_tasas_aporte(file,s)
assign(paste0(tolower(file),'_',tolower(s)) ,plot_tasas_aporte(file,s))



file <- "ivm_largo"
s <- 'Voluntario'
plot_tasas_aporte(file,s)
assign(paste0(tolower(file),'_',tolower(s)) ,plot_tasas_aporte(file,s))


#Agrupar en solo gráfico----------------------------------------------------------------------------

legend = gtable_filter(ggplot_gtable(ggplot_build(ivm_largo_privado)), "guide-box")


g1<- grid.arrange( arrangeGrob(ivm_largo_privado + theme(legend.position="none"),
                         ivm_largo_bancario + theme(legend.position="none"),
                         ivm_largo_público + theme(legend.position="none"), 
                         `ivm_largo_industria azucarera` + theme(legend.position="none"),
                         `ivm_largo_servicio exterior` + theme(legend.position="none"),
                         ivm_largo_voluntario + theme(legend.position="none"),
                         nrow = 3),
             legend,
             heights=c(1.5, 0.05),
             nrow = 2)


ggsave( plot = g1, 
        filename = paste0( parametros$resultado_graficos, 'iess_tasas_ivm', parametros$graf_ext ),
        width = 21, height = 28, units = graf_units, dpi = graf_dpi )



#RT-------------------------------------------------------------------------------------------------
file <- "rt_largo"
s <- 'Público'

aux <- get(file) %>%
  filter( sector == s)

iess_graf <- ggplot( data = aux ) + 
  geom_line( aes( x = fecha, 
                  y = cd_501, 
                  colour ="C.D.501" ), 
             size = graf_line_size,
             lineend = "round" ) + 
  geom_line( aes( x = fecha, 
                  y = cd_261, 
                  colour ="C.D.261" ), 
             size = graf_line_size,
             lineend = "round" ) + 
  scale_x_date(date_breaks = "1 year", date_labels = "%b-%Y")+
  scale_y_continuous( labels = scales::percent_format( accuracy = 0.01,
                                                       decimal.mark = ','),
                     #limits = c(0.05, 0.11),
                     breaks=pretty_breaks( n = 6 )
  ) +
  scale_colour_manual("", 
                      breaks = c("C.D.501", "C.D.261"), 
                      values = c("C.D.501" = parametros$iess_green , 
                                 "C.D.261" = parametros$iess_blue),
                      labels = c("Resolución No. C.D.501", 
                                 "Resolución No. C.D.261") ) +
  labs( x = '', y = paste0('Tasa aportación ', 'SGRT' ) ) +
  theme_bw() +
  plt_theme +
  theme(legend.position="bottom") +
  theme( axis.text.x = element_text(angle = 90, hjust = 1 ) )

ggsave( plot = iess_graf, 
        filename = paste0( parametros$resultado_graficos,
                           'iess_tasa_', 
                           tolower(file), 
                           '_',
                           tolower(s),
                           parametros$graf_ext ),
        width = graf_width, height = graf_height, units = graf_units, dpi = graf_dpi )



file <- "rt_largo"
s <- 'Industria azucarera'

aux <- get(file) %>%
  filter( sector == s)

iess_graf <- ggplot( data = aux ) + 
  geom_line( aes( x = fecha, 
                  y = cd_501, 
                  colour ="C.D.501" ), 
             size = graf_line_size,
             lineend = "round" ) + 
  geom_line( aes( x = fecha, 
                  y = cd_261, 
                  colour ="C.D.261" ), 
             size = graf_line_size,
             lineend = "round" ) + 
  scale_x_date(date_breaks = "1 year", date_labels = "%b-%Y")+
  scale_y_continuous( labels = scales::percent_format( accuracy = 0.01,
                                                       decimal.mark = ','),
                      #limits = c(0.05, 0.11),
                      breaks=pretty_breaks( n = 6 )
  ) +
  scale_colour_manual("", 
                      breaks = c("C.D.501", "C.D.261"), 
                      values = c("C.D.501" = parametros$iess_green , 
                                 "C.D.261" = parametros$iess_blue),
                      labels = c("Resolución No. C.D.501", 
                                 "Resolución No. C.D.261") ) +
  labs( x = '', y = paste0('Tasa aportación ', 'SGRT' ) ) +
  theme_bw() +
  plt_theme +
  theme(legend.position="bottom") +
  theme( axis.text.x = element_text(angle = 90, hjust = 1 ) )

ggsave( plot = iess_graf, 
        filename = paste0( parametros$resultado_graficos,
                           'iess_tasa_', 
                           tolower(file), 
                           '_',
                           tolower(s),
                           parametros$graf_ext ),
        width = graf_width, height = graf_height, units = graf_units, dpi = graf_dpi )




file <- "rt_largo"
s <- 'Voluntario'

aux <- get(file) %>%
  filter( sector == s)

iess_graf <- ggplot( data = aux ) + 
  geom_line( aes( x = fecha, 
                  y = cd_501, 
                  colour ="C.D.501" ), 
             size = graf_line_size,
             lineend = "round" ) + 
  geom_line( aes( x = fecha, 
                  y = cd_261, 
                  colour ="C.D.261" ), 
             size = graf_line_size,
             lineend = "round" ) + 
  scale_x_date(date_breaks = "1 year", date_labels = "%b-%Y")+
  scale_y_continuous( labels = scales::percent_format( accuracy = 0.01,
                                                       decimal.mark = ','),
                      #limits = c(0.05, 0.11),
                      breaks=pretty_breaks( n = 6 )
  ) +
  scale_colour_manual("", 
                      breaks = c("C.D.501", "C.D.261"), 
                      values = c("C.D.501" = parametros$iess_green , 
                                 "C.D.261" = parametros$iess_blue),
                      labels = c("Resolución No. C.D.501", 
                                 "Resolución No. C.D.261") ) +
  labs( x = '', y = paste0('Tasa aportación ', 'SGRT' ) ) +
  theme_bw() +
  plt_theme +
  theme(legend.position="bottom") +
  theme( axis.text.x = element_text(angle = 90, hjust = 1 ) )

ggsave( plot = iess_graf, 
        filename = paste0( parametros$resultado_graficos,
                           'iess_tasa_', 
                           tolower(file), 
                           '_',
                           tolower(s),
                           parametros$graf_ext ),
        width = graf_width, height = graf_height, units = graf_units, dpi = graf_dpi )


#Salud----------------------------------------------------------------------------------------------


file <- "salud_largo"
s <- 'Privado'
plot_tasas_aporte(file,s)
assign(paste0(tolower(file),'_',tolower(s)) ,plot_tasas_aporte(file,s))



file <- "salud_largo"
s <- 'Bancario'
plot_tasas_aporte(file,s)
assign(paste0(tolower(file),'_',tolower(s)) ,plot_tasas_aporte(file,s))



file <- "salud_largo"
s <- 'Público'
plot_tasas_aporte(file,s)
assign(paste0(tolower(file),'_',tolower(s)) ,plot_tasas_aporte(file,s))



file <- "salud_largo"
s <- 'Servicio exterior'
plot_tasas_aporte(file,s)
assign(paste0(tolower(file),'_',tolower(s)) ,plot_tasas_aporte(file,s))



file <- "salud_largo"
s <- 'Industria azucarera'
plot_tasas_aporte(file,s)
assign(paste0(tolower(file),'_',tolower(s)) ,plot_tasas_aporte(file,s))



file <- "salud_largo"
s <- 'Voluntario'
plot_tasas_aporte(file,s)
assign(paste0(tolower(file),'_',tolower(s)) ,plot_tasas_aporte(file,s))


#Agrupar en solo gráfico----------------------------------------------------------------------------

legend = gtable_filter(ggplot_gtable(ggplot_build(salud_largo_privado)), "guide-box")


g1<- grid.arrange( arrangeGrob(salud_largo_privado + theme(legend.position="none"),
                               salud_largo_bancario + theme(legend.position="none"),
                               salud_largo_público + theme(legend.position="none"), 
                               `salud_largo_industria azucarera` + theme(legend.position="none"),
                               `salud_largo_servicio exterior` + theme(legend.position="none"),
                               salud_largo_voluntario + theme(legend.position="none"),
                               nrow = 3),
                   legend,
                   heights=c(1.5, 0.05),
                   nrow = 2)


ggsave( plot = g1, 
        filename = paste0( parametros$resultado_graficos, 'iess_tasas_ivm', parametros$graf_ext ),
        width = 21, height = 28, units = graf_units, dpi = graf_dpi )




###################################################################################################
message( paste( rep('-', 100 ), collapse = '' ) )
rm( list = ls()[ !( ls() %in% c( 'parametros' ) ) ] )
gc()