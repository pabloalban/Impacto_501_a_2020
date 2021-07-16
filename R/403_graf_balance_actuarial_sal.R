message( paste( rep('-', 100 ), collapse = '' ) )
message( '\tGraficando resultados del balance' )

source( 'R/401_graf_plantilla.R', encoding = 'UTF-8', echo = FALSE )

escenarios_lista <- paste0( 'escenario_', 1:2 ) # 4 escenarios 

# Escenarios dinámicos -----------------------------------------------------------------------------
# for ( i in 1:length( escenarios_lista ) ) {
#   escenario <- escenarios_lista[i]
#   #escenario <- escenarios_lista[1]
#   load( paste0( parametros$RData_seg, 'IESS_IVM_balances_', escenario, '.RData' ) )

# num_anios <- length( unique( balance_anual$t ) )
# cols_fun <- colorRampPalette( c( 'gold', parametros$iess_green, parametros$iess_blue ) )
# cols_graf <- cols_fun( num_anios )
# 
# balance_anual[ , t := t + parametros$anio_ini ]
# # grafico balance actuarial ----------------------------------------------------------------------
# x_lim <- c( parametros$anio_ini, parametros$anio_ini + parametros$horizonte )
# x_brk <- seq( x_lim[1], x_lim[2], 5 )
# x_lbl <- formatC( x_brk, digits = 0, format = 'f' )
# 
# y_lim <- c( min( balance_anual$V ), max( balance_anual$V ) )
# y_brk <- unique( pretty( seq(y_lim[1], y_lim[2], length.out = 5) ) )
# y_lim <- c( min(y_brk), max(y_brk) ) # redefiniendo limites por razones estéticas
# y_lbl <- formatC(y_brk/1e6, digits = 0, format = 'f', big.mark = '.', decimal.mark = ',')
# 
# plt_bal_act <-  ggplot() +
#   geom_line( data = balance_anual, aes( x = t, y = V ), 
#              size = graf_line_size, color = parametros$iess_blue ) +
#   geom_hline( aes( yintercept = 0 ), 
#               size = 0.5*graf_line_size, 
#               color = parametros$iess_green, 
#               linetype = 2 ) +
#   xlab( 'Año') +
#   ylab( 'Balance actuarial dinámico (millones)' ) +
#   scale_x_continuous( limits = x_lim, breaks = x_brk, labels = x_lbl ) +
#   scale_y_continuous( limits = y_lim, breaks = y_brk, labels = y_lbl  ) +
#   theme_bw() +
#   plt_theme
# 
# # plt_bal_act
# 
# ggsave( plot = plt_bal_act, 
#         filename = paste0( parametros$resultado_graficos, 'iess_balance_vap_', escenario, parametros$graf_ext ),
#         width = graf_width, height = graf_height, units = graf_units, dpi = graf_dpi )
# 
# #Gráfico del balance actuarial con barras-----------------------------------------------------------
# x_lim <- c( parametros$anio_ini, parametros$anio_ini + parametros$horizonte )
# x_brk <- seq( x_lim[1], x_lim[2], 5 )
# x_lbl <- formatC( x_brk, digits = 0, format = 'f' )
# 
# y_lim <- c( 0, max( balance_anual$V ) )
# y_brk <- unique( pretty( seq(y_lim[1], y_lim[2], length.out = 5) ) )
# y_lim <- c( min(y_brk), max(y_brk) ) # redefiniendo limites por razones estéticas
# y_lbl <- formatC(y_brk/1e6, digits = 0, format = 'f', big.mark = '.', decimal.mark = ',')
# 
# plt_bal_act <-  ggplot() +
#   geom_bar( data = balance_anual[V>=0], aes( x = t, y = V ) , stat = 'identity', 
#             fill=parametros$iess_blue, width=0.5) +
#   geom_bar( data = balance_anual[V<0], aes( x = t, y = V ) , stat = 'identity', 
#             fill='red',  width=0.5) +
#   geom_hline( aes( yintercept = 0 ), 
#               size = 0.5*graf_line_size, 
#               color = parametros$iess_green,
#               linetype = 2 ) +
#   xlab( 'Año') +
#   ylab( 'Balance actuarial dinámico (millones)' ) +
#   scale_x_continuous(  breaks = x_brk, labels = x_lbl ) +
#   scale_y_continuous(  breaks = y_brk, labels = y_lbl  ) +
#   theme_bw() +
#   plt_theme
# 
# # plt_bal_act
# 
# ggsave( plot = plt_bal_act, 
#         filename = paste0( parametros$resultado_graficos, 'iess_balance_vap_rv_', escenario, parametros$graf_ext ),
#         width = graf_width, height = graf_height, units = graf_units, dpi = graf_dpi )
# 

# grafico aportes y beneficios -------------------------------------------------------------------
#   y_lim <- c( min( balance_anual[ , list(A_vap, B_vap)] ), max( balance_anual[ , list(A_vap, B_vap)] ) )
#   y_brk <- unique( pretty( seq(y_lim[1], y_lim[2], length.out = 5) ) )
#   y_lim <- c( min(y_brk), max(y_brk) ) # redefiniendo limites por razones estéticas
#   y_lbl <- formatC(y_brk/1e6, digits = 0, format = 'f', big.mark = '.', decimal.mark = ',')
#   
#   
#   aux1 <- balance_anual[ , list(item = 'Aportes', t = t, valor = A_vap) ]
#   aux2 <- balance_anual[ , list(item = 'Beneficios', t = t, valor = B_vap) ] 
#   
#   aux <- rbind(aux1, aux2)
#   plt_apo_ben_act <-  ggplot( aux, aes( x = t, y = valor ) ) +
#     geom_line( aes(colour = item), size = graf_line_size ) +
#     xlab( 'Año' ) +
#     ylab( 'Aportes y Beneficios Balance Dinámico (millones)' ) +
#     scale_y_continuous( limits = y_lim, breaks = y_brk, labels = y_lbl ) +
#     scale_x_continuous( breaks = x_brk, labels = x_lbl, limits = x_lim ) +
#     theme_bw() +
#     scale_colour_manual( values = c('Aportes' = parametros$iess_blue,
#                                     'Beneficios' = parametros$iess_green) ) +
#     plt_theme +
#     theme(legend.position="bottom") +
#     labs( x = '', y = '' )+
#     theme( axis.text.x = element_text(angle = 90, hjust = 1 ) )
#   
#   # plt_apo_ben_act
#   
#   ggsave( plot = plt_apo_ben_act, 
#           filename = paste0( parametros$resultado_graficos, 'iess_apo_ben_bal_dinamico_', escenario, parametros$graf_ext ),
#           width = graf_width, height = graf_height, units = graf_units, dpi = graf_dpi )
#}

#Gráficos coomparación ingresos CD. 261 y CD 501----------------------------------------------------
load( paste0( parametros$RData_seg, 'IESS_SAL_balances_', "escenario_1", '.RData' ) )
aux_1<- as_tibble(balance_anual[ , t := t + parametros$anio_ini ]) %>%
  select(t,A_1:=A2_vap,B_1:=B_vap,V_1:=V)

load( paste0( parametros$RData_seg, 'IESS_SAL_balances_', "escenario_2", '.RData' ) )
aux_2<- as_tibble(balance_anual[ , t := t + parametros$anio_ini ]) %>%
  select(t,A_2:=A2_vap,B_2:=B_vap,V_2:=V)

aux <- left_join(aux_1,aux_2,by='t') %>% filter( t>2018)

#Gráfico de comparación de balance actuarial--------------------------------------------------------
num_anios <- length( unique( aux$t ) )
cols_fun <- colorRampPalette( c( 'gold', parametros$iess_green, parametros$iess_blue ) )
cols_graf <- cols_fun( num_anios )
x_lim <- c( parametros$anio_ini, parametros$anio_ini + parametros$horizonte )
x_brk <- seq( x_lim[1], x_lim[2], 5 )
x_lbl <- formatC( x_brk, digits = 0, format = 'f' )

y_lim <- c( min( aux$V_1,aux$V_2 ), max( aux$V_1 ) )
y_brk <- unique( pretty( seq(y_lim[1], y_lim[2], length.out = 5) ) )
y_lim <- c( min(y_brk), max(y_brk) ) # redefiniendo limites por razones estéticas
y_lbl <- formatC(y_brk/1e6, digits = 0, format = 'f', big.mark = '.', decimal.mark = ',')


compa_bal_act <-  ggplot() +
                  geom_line( data = aux, aes( x = t, y = V_1 , colour ="C.D.261"), 
                             size = 1 ) +
                  geom_line( data = aux, aes( x = t, y = V_2 , colour ="C.D.501"), 
                             size = 1) +
                  geom_hline( aes( yintercept = 0 ),
                              size = 0.5*graf_line_size,
                              color = 'black',
                              linetype = 2 ) +
                  xlab( 'Año') +
                  ylab( 'Balance actuarial dinámico (USD millones)' ) +
                  scale_x_continuous( limits = x_lim, breaks = x_brk, labels = x_lbl ) +
                  scale_y_continuous( limits = y_lim, breaks = y_brk, labels = y_lbl  ) +
                  scale_colour_manual("", 
                                      breaks = c("C.D.261", "C.D.501" ), 
                                      values = c("C.D.261" = parametros$iess_blue,
                                                 "C.D.501" = 'red'))+
                  scale_linetype_manual(breaks = c("C.D.261", "C.D.501" ),values= c('solid', 'dash'))+
                  theme_bw() +
                  plt_theme +
                  theme(legend.position="bottom") +
                  theme( axis.text.x = element_text(angle = 90, hjust = 1 ) )


ggsave( plot = compa_bal_act, 
        filename = paste0( parametros$resultado_graficos, 'iess_compa_bal_act_sal', parametros$graf_ext ),
        width = graf_width, height = graf_height, units = graf_units, dpi = graf_dpi )



#comparación de ingresos----------------------------------------------------------------------------

num_anios <- length( unique( aux$t ) )
cols_fun <- colorRampPalette( c( 'gold', parametros$iess_green, parametros$iess_blue ) )
cols_graf <- cols_fun( num_anios )
x_lim <- c( parametros$anio_ini, parametros$anio_ini + parametros$horizonte )
x_brk <- seq( x_lim[1], x_lim[2], 5 )
x_lbl <- formatC( x_brk, digits = 0, format = 'f' )

y_lim <- c( min( aux$A_2 ), max( aux$A_1 ) )
y_brk <- unique( pretty( seq(y_lim[1], y_lim[2], length.out = 5) ) )
y_lim <- c( min(y_brk), max(y_brk) ) # redefiniendo limites por razones estéticas
y_lbl <- formatC(y_brk/1e6, digits = 0, format = 'f', big.mark = '.', decimal.mark = ',')


compa_ing_act <-  ggplot() +
                  geom_line( data = aux, aes( x = t, y = A_1 , colour ="C.D.261"), 
                             size = 1 ) +
                  geom_line( data = aux, aes( x = t, y = A_2 , colour ="C.D.501"), 
                             size = 1) +
                  xlab( 'Año') +
                  ylab( 'Aportes de afiliados (USD millones)' ) +
                  scale_x_continuous( limits = x_lim, breaks = x_brk, labels = x_lbl ) +
                  scale_y_continuous( limits = y_lim, breaks = y_brk, labels = y_lbl  ) +
                  scale_colour_manual("", 
                                      breaks = c("C.D.261", "C.D.501" ), 
                                      values = c("C.D.261" = parametros$iess_blue,
                                                 "C.D.501" = 'red'))+
                  scale_linetype_manual(breaks = c("C.D.261", "C.D.501" ),values= c('solid', 'dash'))+
                  theme_bw() +
                  plt_theme +
                  theme(legend.position="bottom") +
                  theme( axis.text.x = element_text(angle = 90, hjust = 1 ) )

ggsave( plot = compa_ing_act, 
        filename = paste0( parametros$resultado_graficos, 'iess_compa_ing_act_sal', parametros$graf_ext ),
        width = graf_width, height = graf_height, units = graf_units, dpi = graf_dpi )

# Limpieza -----------------------------------------------------------------------------------------
message( paste( rep('-', 100 ), collapse = '' ) )
rm( list = ls()[ !( ls() %in% c( 'parametros' ) ) ] )
gc()
