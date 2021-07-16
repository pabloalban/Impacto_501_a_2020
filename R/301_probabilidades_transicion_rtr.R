message( paste( rep('-', 100 ), collapse = '' ) )

# Cargando información -----------------------------------------------------------------------------
message( '\tCargando datos' )
load( paste0( parametros$RData, 'ONU_interpolado_life_table_survivors_2019.RData' ) )
load( paste0( parametros$RData, 'IESS_estimacion_tasa_entradas.RData' ) )
load( paste0( parametros$RData, 'IESS_tabla_mortalidad_dinamica.RData' ) )
load( paste0( parametros$RData, 'IESS_estimacion_tasa_actividad.RData' ) )
load( paste0( parametros$RData, 'IESS_estimacion_tasa_mortalidad_pensionistas.RData' ) )
load( paste0( parametros$RData_seg, 'IESS_RTR_tabla_decrementos.RData' ) ) 
load( paste0( parametros$RData_seg, 'IESS_RTR_tasa_mortalidad_pensionistas_int.RData' ) ) 
load( paste0( parametros$RData_seg, 'IESS_SGO_tasa_decremento_act_invalidez_int.RData' ) ) 
# Borrando variables, solo quedan variables a ser utilizadas
rm( list = ls()[ !( ls() %in% c( parametros_lista, 'parametros', 'tab_dec', 'tasa_ent_esp', 'onu_ecu_mort_din', 
                                 'iess_mort_din', 'tasa_mort_vej_proy', 'tasa_mort_inv_proy', 
                                 'pob_ini', 'tasa_act_proy','mortalidad_jubilados_rtr_int',
                                 'trans_activo_invalidez') ) ] )

#Configuración del modelo de cadenas de Markov en tiempo continuo-----------------------------------
message( '\tConfiguración del modelo de cadenas de Markov en tiempo continuo de RTR' )
# Horizonte de proyección
t_horiz <- 40

# Año inicial de proyección
fec_ini <- 2018

# Año final de proyección
fec_fin <- fec_ini + t_horiz

# Tiempo
t <- 0:t_horiz

# Edades
x_max <- 105
x <- 0:x_max

N <- length( t )
M <- length( x )

# Arrays para probabilidades dependientes
Pf <- array( 0.0, dim = c( M, N, 6, 6 ) )
Pm <- array( 0.0, dim = c( M, N, 6, 6 ) )

#Tasas de ir del estado i al j----------------------------------------------------------------------
message( '\tPreparando tasas de ir del estado i al j' )
# Tasa de actividad --------------------------------------------------------------------------------
message( '\tPreparando tasa de actividad de afiliados' )
tau_f <- merge( data.table( x = x ), 
                tasa_act_proy[ sexo == 'F', list( x, tau ) ],
                by = 'x', all.x = TRUE )
tau_f[ is.na( tau ), tau := 0 ]
setorder( tau_f, x )
tau_f <- as.matrix( tau_f[ , 2 ] )

tau_m <- merge( data.table( x = x ), 
                tasa_act_proy[ sexo == 'M', list( x, tau ) ],
                by = 'x', all.x = TRUE )
tau_m[ is.na( tau ), tau := 0 ]
setorder( tau_m, x )
tau_m <- as.matrix( tau_m[ , 2 ] )

# Tasa de entrada de afiliados ---------------------------------------------------------------------
message( '\tPreparando tasa de entrada de afililiados' )
ue_f <- merge( data.table( x = x ), 
               tasa_ent_esp[ sexo == 'F', list( x, ue ) ],
               by = 'x', all.x = TRUE )
ue_f[ is.na( ue ), ue := 0 ]
setorder( ue_f, x )
ue_f <- as.matrix( ue_f[ , 2 ] )

ue_m <- merge( data.table( x = x ), 
               tasa_ent_esp[ sexo == 'F', list( x, ue ) ],
               by = 'x', all.x = TRUE )
ue_m[ is.na( ue ), ue := 0 ]
setorder( ue_m, x )
ue_m <- as.matrix( ue_m[ , 2 ] )

# Tasa de mortalidad de no afiliados ---------------------------------------------------------------
message( '\tPreparando tasa de mortalidad de no afililiados' )
u_f <- onu_ecu_mort_din[ sexo == 'F' & t >= fec_ini & t <= fec_fin & x <= x_max, 
                         list( t = t - fec_ini, x, ux ) ]
setorder( u_f, t, x )
u_f <- dcast.data.table( data = u_f, x ~ t, value.var = 'ux' )
u_f <- as.matrix( u_f[ , 2:ncol( u_f ) ] )

u_m <- onu_ecu_mort_din[ sexo == 'M' & t >= fec_ini & t <= fec_fin & x <= x_max, 
                         list( t = t - fec_ini, x, ux ) ]
setorder( u_m, t, x )
u_m <- dcast.data.table( data = u_m, x ~ t, value.var = 'ux' )
u_m <- as.matrix( u_m[ , 2:ncol( u_m ) ] )

# Tasa mortalidad afililiados ----------------------------------------------------------------------
message( '\tPreparando tasa de mortalidad de afililiados' )
ud_f <- iess_mort_din[ sexo == 'F' & t >= fec_ini & t <= fec_fin & x <= x_max, 
                       list( t = t - fec_ini, x, ux ) ]
setorder( ud_f, t, x )
ud_f <- dcast.data.table( data = ud_f, x ~ t, value.var = 'ux' )
ud_f <- as.matrix( ud_f[ , 2:ncol( ud_f ) ] )

ud_m <- iess_mort_din[ sexo == 'M' & t >= fec_ini & t <= fec_fin & x <= x_max, 
                       list( t = t - fec_ini, x, ux ) ]
setorder( ud_m, t, x )
ud_m <- dcast.data.table( data = ud_m, x ~ t, value.var = 'ux' )
ud_m <- as.matrix( ud_m[ , 2:ncol( ud_m ) ] )

# Tasa mortalidad pensionistas ---------------------------------------------------------------------
message( '\tPreparando tasa de mortalidad de pensionistas por vejez' )
udv_f <- iess_mort_din[ sexo == 'F' & t >= fec_ini & t <= fec_fin & x <= x_max, 
                        list( t = t - fec_ini, x, uvx ) ]
setorder( udv_f, t, x )
udv_f <- dcast.data.table( data = udv_f, x ~ t, value.var = 'uvx' )
udv_f <- as.matrix( udv_f[ , 2:ncol( udv_f ) ] )

udv_m <- iess_mort_din[ sexo == 'M' & t >= fec_ini & t <= fec_fin & x <= x_max, 
                        list( t = t - fec_ini, x, uvx ) ]
setorder( udv_m, t, x )
udv_m <- dcast.data.table( data = udv_m, x ~ t, value.var = 'uvx' )
udv_m <- as.matrix( udv_m[ , 2:ncol( udv_m ) ] )

# Tasa mortalidad inválidos ------------------------------------------------------------------------
message( '\tPreparando tasa de mortalidad de pensionistas por invalidez' )
udi_f <- iess_mort_din[ sexo == 'F' & t >= fec_ini & t <= fec_fin & x <= x_max, 
                        list( t = t - fec_ini, x, uix ) ]
setorder( udi_f, t, x )
udi_f <- dcast.data.table( data = udi_f, x ~ t, value.var = 'uix' )
udi_f <- as.matrix( udi_f[ , 2:ncol( udi_f ) ] )

udi_m <- iess_mort_din[ sexo == 'M' & t >= fec_ini & t <= fec_fin & x <= x_max, 
                        list( t = t - fec_ini, x, uix ) ]
setorder( udi_m, t, x )
udi_m <- dcast.data.table( data = udi_m, x ~ t, value.var = 'uix' )
udi_m <- as.matrix( udi_m[ , 2:ncol( udi_m ) ] )

# Tasa de salida vejez de IVM-----------------------------------------------------------------------
message( '\tPreparando tasa de salida de afiliados por vejez' )
uv_f <- merge( data.table( x = x ), 
               tab_dec[ sexo == 'F', list( x, uv ) ],
               by = 'x', all.x = TRUE )
uv_f[ is.na( uv ), uv := 0 ]
setorder( uv_f, x )
uv_f <- as.matrix( uv_f[ , 2 ] )

uv_m <- merge( data.table( x = x ), 
               tab_dec[ sexo == 'M', list( x, uv ) ],
               by = 'x', all.x = TRUE )
uv_m[ is.na( uv ), uv := 0 ]
setorder( uv_m, x )
uv_m <- as.matrix( uv_m[ , 2 ] )

# Tasa de salida invalidez de IVM-------------------------------------------------------------------
message( '\tPreparando tasa de salida de afiliados por invalidez' )
ui_f <- merge( data.table( x = x ), 
                tab_dec[ sexo == 'F', list( x, ui ) ],
                by = 'x', all.x = TRUE )
ui_f[ is.na( ui ), ui := 0 ]
setorder( ui_f, x )
ui_f <- as.matrix( ui_f[ , 2 ] )

ui_m <- merge( data.table( x = x ), 
                tab_dec[ sexo == 'M', list( x, ui ) ],
                by = 'x', all.x = TRUE )
ui_m[ is.na( ui ), ui := 0 ]
setorder( ui_m, x )
ui_m <- as.matrix( ui_m[ , 2 ] )

#Tasa de salida a PT y PA de RTR--------------------------------------------------------------------
message( '\tPreparando tasa de salida de afiliados por incapacidad PT y PA de RTR' )
uin_f <- merge( data.table( x = x ), 
               tab_dec[ sexo == 'F', list( x, uin ) ],
               by = 'x', all.x = TRUE )
uin_f[ is.na( uin ), uin := 0 ]
setorder( uin_f, x )
uin_f <- as.matrix( uin_f[ , 2 ] )

uin_m <- merge( data.table( x = x ), 
               tab_dec[ sexo == 'M', list( x, uin ) ],
               by = 'x', all.x = TRUE )
uin_m[ is.na( uin ), uin := 0 ]
setorder( uin_m, x )
uin_m <- as.matrix( uin_m[ , 2 ] )

#No se otorgan jubilaciones de PP desde el año 2015

# Tasa mortalidad pensionistas de RTR---------------------------------------------------------------
message( '\tPreparando tasa de mortalidad de pensionistas de RTR por PA, PT y PP' )
udin_f <- merge( data.table( x = x ), 
                tab_dec[ sexo == 'F', list( x, udin ) ],
                by = 'x', all.x = TRUE )
udin_f[ is.na( udin ), udin := 0 ]
setorder( udin_f, x )
udin_f <- as.matrix( udin_f[ , 2 ] )

udin_m <- merge( data.table( x = x ), 
                tab_dec[ sexo == 'M', list( x, udin ) ],
                by = 'x', all.x = TRUE )
udin_m[ is.na( udin ), udin := 0 ]
setorder( udin_m, x )
udin_m <- as.matrix( udin_m[ , 2 ] )


#Construcción de la matriz Q------------------------------------------------------------------------
message( '\tConstrucción de la matriz Q y calculando la matriz de transiciones estocástica P' )
for ( n in 1:N ) {
  for ( k in 1:M ) {
  
Uf <- c( 0, ue_f[ k, 1 ],            0,            0,              0,     u_f[ k, n ],   
         0,            0, uv_f[ k, 1 ], ui_f[ k, 1 ],  uin_f[ k, 1 ],    ud_f[ k, n ],
         0,            0,            0,            0,              0,   udv_f[ k, n ],
         0,            0,            0,            0,              0,   udi_f[ k, n ],
         0,            0,            0,            0,              0,  udin_f[ k, 1 ],
         0,            0,            0,            0,              0,               0 )

Um <- c( 0, ue_m[ k, 1 ],            0,            0,              0,     u_m[ k, n ],   
         0,            0, uv_m[ k, 1 ], ui_m[ k, 1 ],  uin_m[ k, 1 ],    ud_m[ k, n ],
         0,            0,            0,            0,              0,   udv_m[ k, n ],
         0,            0,            0,            0,              0,   udi_m[ k, n ],
         0,            0,            0,            0,              0,  udin_m[ k, 1 ],
         0,            0,            0,            0,              0,               0 )
    
    Uf <- matrix( Uf, 6, 6, byrow = TRUE )
    Df <- matrix( 0, 6, 6, byrow = TRUE )
    diag( Df ) <- -rowSums( Uf )
    Uf <- Uf + Df
    
    Um <- matrix( Um, 6, 6, byrow = TRUE )
    Dm <- matrix( 0, 6, 6, byrow = TRUE )
    diag( Dm ) <- -rowSums( Um )
    Um <- Um + Dm

# Encontrando la matriz de transiciones estocástica P-----------------------------------------------
    Sf <- eigen( Uf )
    Df <- diag( exp( Sf$values ) )
    Uf <- Sf$vectors %*% Df %*% solve( Sf$vectors )
    Uf <- apply( Uf, c( 1, 2 ), FUN = function( x ) ifelse( x < 1e-10, 0, x ) )
    
    Sm <- eigen( Um )
    Dm <- diag( exp( Sm$values ) )
    Um <- Sm$vectors %*% Dm %*% solve( Sm$vectors )
    Um <- apply( Um, c( 1, 2 ), FUN = function( x ) ifelse( x < 1e-10, 0, x ) )
    
    Pf[ k, n, , ] <- t( Uf )
    Pm[ k, n, , ] <- t( Um )
    
  }
}

#Guardar la matriz estocástica de Transiciones P en un data frame-----------------------------------
save( Pf, Pm, Uf, Um, tau_f, tau_m,
      file = paste0( parametros$RData_seg, 'IESS_RTR_probabilidades_transicion.RData' ) )

#Limpiar memoria------------------------------------------------------------------------------------
message( paste( rep('-', 100 ), collapse = '' ) )
rm( list = ls()[ !( ls() %in% c( parametros_lista, 'parametros' ) ) ] )
gc()
