message( paste( rep('-', 100 ), collapse = '' ) )

# Cargando información -----------------------------------------------------------------------------
message( '\tCargando datos' )
load( paste0( parametros$RData, 'IESS_onu_pea_ecu_int.RData' ) )
load( paste0( parametros$RData, 'IESS_poblacion_inicial.RData' ) )
load( paste0( parametros$RData_seg, 'IESS_RTR_probabilidades_transicion.RData' ) )
load( paste0( parametros$RData_seg, 'IESS_RTR_poblacion_inicial.RData' ) )
load( paste0( parametros$RData, 'IESS_estimacion_tasa_actividad.RData' ) )
load( paste0( parametros$RData_seg, 'IESS_RTR_siniestralidad_indemnizaciones_edad_sexo_int.RData' ) )
load( paste0( parametros$RData_seg, 'IESS_RTR_siniestralidad_subsidios_edad_sexo_int.RData' ) )
load( paste0( parametros$RData_seg, 'IESS_RTR_siniestralidad_accidentes_laborales_fatales.RData' ) )
load( paste0( parametros$RData_seg, 'IESS_RTR_grupo_familiar.RData' ) )
load( paste0( parametros$RData_seg, 'IESS_RTR_fdp_ingresos_huerfanos_montepio.RData' ) )
load( paste0( parametros$RData_seg, 'IESS_RTR_fdp_ingresos_viudas_montepio.RData' ) )


# Borrando variables, solo quedan variables a ser utilizadas----------------------------------------
rm( list = ls()[ !( ls() %in% c( parametros_lista, 'parametros', 'tasa_act_proy', 
                                 'onu_pea_tot_int', 'pob_ini','pob_ini_rtr',
                                 'Pf', 'Pm', 'tau_f', 'tau_m',
                                 'siniestralidad_indeminizaciones_edad_sexo_int',
                                 'siniestralidad_subsidios_edad_sexo_int',
                                 'incidencia_FA',
                                 'GF_viudez','GF_orfandad','rho',
                                 'fdp_ingresos_viudas_edad_sexo',
                                 'fdp_ingresos_huerfanos_edad_sexo') ) ] )
# Horizonte de proyección
t_horiz <- parametros$horizonte

# Año inicial de proyección
fec_ini <- parametros$anio_ini

# Año final de proyección
fec_fin <- fec_ini + t_horiz

# Tiempo
t <- 0:t_horiz

# Edades
x_max <- parametros$edad_max
x <- 0:x_max

N <- length( t )
M <- length( x )

# Arrays para población
lf <- array( 0.0, dim = c( M, N, 6 ) )
lm <- array( 0.0, dim = c( M, N, 6 ) )

# Conteos de transición
ltf <- array( 0.0, dim = c( M, N, 14 ) )
ltm <- array( 0.0, dim = c( M, N, 14 ) )

# PEA ----------------------------------------------------------------------------------------------
message( '\tPreparando población económicamente activa' )
PEA_f <- onu_pea_tot_int[ sex == 'F' & year >= fec_ini & year <= fec_fin & x <= x_max, 
                          list( t = year - fec_ini, x, pea = pea_int ) ]
PEA_f[ , pea := ( pmin( 0.7 * ( 1.03566749 )^t, 1 ) ) * pea ] # calibrando crecimiento PEA
PEA_f <- merge( data.table( expand.grid( t = t, x = x ) ),
                PEA_f, by = c( 't', 'x' ), all.x = TRUE )
PEA_f[ is.na( pea ), pea := 0 ]
setorder( PEA_f, t, x )
PEA_f <- dcast.data.table( data = PEA_f, x ~ t, value.var = 'pea' )
PEA_f <- as.matrix( PEA_f[ , 2:ncol( PEA_f ) ] )

PEA_m <- onu_pea_tot_int[ sex == 'M' & year >= fec_ini & year <= fec_fin & x <= x_max, 
                          list( t = year - fec_ini, x, pea = pea_int ) ]
PEA_m[ , pea := ( pmin( 0.7 * ( 1.03566749 )^t, 1 ) ) * pea ] # calibrando crecimiento PEA
PEA_m <- merge( data.table( expand.grid( t = t, x = x ) ),
                PEA_m, by = c( 't', 'x' ), all.x = TRUE )
PEA_m[ is.na( pea ), pea := 0 ]
setorder( PEA_m, t, x )
PEA_m <- dcast.data.table( data = PEA_m, x ~ t, value.var = 'pea' )
PEA_m <- as.matrix( PEA_m[ , 2:ncol( PEA_m ) ] )

#Preparando tablas de siniestralidad de Indemnizaciones y subsidios---------------------------------
sin_ind <- siniestralidad_indeminizaciones_edad_sexo_int[ , list(x,sexo,tasa_sin_indem_int) ]

#Preparando tablas de siniestralidad de subsidios---------------------------------------------------
sin_sub <- siniestralidad_subsidios_edad_sexo_int[,list(x,sexo,tasa_sin_sub_int)]

# Población inicial --------------------------------------------------------------------------------
message( '\tPreparando población inicial' )
pob_ini<-rbind(pob_ini,pob_ini_rtr[ estado == 'PA_PT' ])
l0_f <- pob_ini[ sexo == 'F', list( x, estado, lx ) ]
setorder( l0_f, x )
l0_f[ estado == 'afi', est := 2 ]
l0_f[ estado == 'pvej', est := 3 ]
l0_f[ estado == 'pinv', est := 4 ]
l0_f[ estado == 'PA_PT', est := 5 ]
l0_f <- dcast.data.table( data = l0_f, formula = x ~ est, value.var = 'lx' )
l0_f <- cbind( l0_f, rep( 0, M ) )
l0_1_f <- PEA_f[ , 1 ]
l0_f <- cbind( l0_f, l0_1_f )
setnames( l0_f, c( 'x', paste0( 'l', c( 2:6, 1 ) ) ) )
l0_f <- cbind( l0_f, tau_f )
# transformando población activa a afiliada
l0_f$l2<-as.numeric(l0_f$l2)
l0_f[ tau > 0, l2 := l2 / tau ] 
l0_f[ , l1 := l1 - l2 ] 
l0_f <- as.matrix( l0_f[ , c( 7, 2, 3, 4, 5, 6 ) ] )


l0_m <- pob_ini[ sexo == 'M', list( x, estado, lx ) ]
setorder( l0_m, x )
l0_m[ estado == 'afi', est := 2 ]
l0_m[ estado == 'pvej', est := 3 ]
l0_m[ estado == 'pinv', est := 4 ]
l0_m[ estado == 'PA_PT', est := 5 ]
l0_m <- dcast.data.table( data = l0_m, formula = x ~ est, value.var = 'lx' )
l0_m <- cbind( l0_m, rep( 0, M ) )
l0_1_m <- PEA_m[ , 1 ]
l0_m <- cbind( l0_m, l0_1_m )
setnames( l0_m, c( 'x', paste0( 'l', c( 2:6, 1 ) ) ) )
l0_m <- cbind( l0_m, tau_m )
# transformando población activa a afiliada
l0_m$l2<-as.numeric(l0_m$l2)
l0_m[ tau > 0, l2 := l2 / tau ]
l0_m[ , l1 := l1 - l2 ]
l0_m <- as.matrix( l0_m[ , c( 7, 2, 3, 4, 5, 6 ) ] )

rm( l0_1_f, l0_1_m )

# Parámetros iniciales -----------------------------------------------------------------------------
message( '\tEstableciendo condición inicial' )
lf[ , 1, ] <- l0_f
lm[ , 1, ] <- l0_m

# Proyección población -----------------------------------------------------------------------------
message( '\tProyectando población' )
for ( n in 1:(N-1) ) {
  for ( k in 1:(M-1) ) {
    #Calculo de los estados en el período de valuación
    lf[ k + 1, n + 1, ] <- Pf[ k, n, , ] %*% lf[ k, n, ]
    lm[ k + 1, n + 1, ] <- Pm[ k, n, , ] %*% lm[ k, n, ]
    
    # Ajuste población activa
    lf[ 1, n + 1, 1 ] <- 0
    lm[ 1, n + 1, 1 ] <- 0
    lf[ k + 1, n + 1, 1 ] <- max( PEA_f[ k + 1, n + 1 ] - tau_f[ k + 1, 1 ] * lf[ k + 1, n + 1, 2 ], 0 )
    lm[ k + 1, n + 1, 1 ] <- max( PEA_m[ k + 1, n + 1 ] - tau_m[ k + 1, 1 ] * lm[ k + 1, n + 1, 2 ], 0 )
    
    # Conteos de transiciones mujeres
    ltf[ k + 1, n + 1, 1 ] <- Pf[ k, n, 1, 1 ] * lf[ k, n, 1 ]
    ltf[ k + 1, n + 1, 2 ] <- Pf[ k, n, 2, 1 ] * lf[ k, n, 1 ]
    ltf[ k + 1, n + 1, 3 ] <- Pf[ k, n, 6, 1 ] * lf[ k, n, 1 ]
    ltf[ k + 1, n + 1, 4 ] <- Pf[ k, n, 2, 2 ] * lf[ k, n, 2 ]
    ltf[ k + 1, n + 1, 5 ] <- Pf[ k, n, 3, 2 ] * lf[ k, n, 2 ]
    ltf[ k + 1, n + 1, 6 ] <- Pf[ k, n, 4, 2 ] * lf[ k, n, 2 ]
    ltf[ k + 1, n + 1, 7 ] <- Pf[ k, n, 5, 2 ] * lf[ k, n, 2 ]
    ltf[ k + 1, n + 1, 8 ] <- Pf[ k, n, 6, 2 ] * lf[ k, n, 2 ]
    ltf[ k + 1, n + 1, 9 ] <- Pf[ k, n, 3, 3 ] * lf[ k, n, 3 ]
    ltf[ k + 1, n + 1, 10 ] <- Pf[ k, n, 6, 3 ] * lf[ k, n, 3 ]
    ltf[ k + 1, n + 1, 11 ] <- Pf[ k, n, 4, 4 ] * lf[ k, n, 4 ]
    ltf[ k + 1, n + 1, 12 ] <- Pf[ k, n, 6, 4 ] * lf[ k, n, 4 ]
    ltf[ k + 1, n + 1, 13 ] <- Pf[ k, n, 5, 5 ] * lf[ k, n, 5 ]
    ltf[ k + 1, n + 1, 14 ] <- Pf[ k, n, 6, 5 ] * lf[ k, n, 5 ]    
    
    # Conteos de transiciones hombres
    ltm[ k + 1, n + 1, 1 ] <- Pm[ k, n, 1, 1 ] * lm[ k, n, 1 ]
    ltm[ k + 1, n + 1, 2 ] <- Pm[ k, n, 2, 1 ] * lm[ k, n, 1 ]
    ltm[ k + 1, n + 1, 3 ] <- Pm[ k, n, 6, 1 ] * lm[ k, n, 1 ]
    ltm[ k + 1, n + 1, 4 ] <- Pm[ k, n, 2, 2 ] * lm[ k, n, 2 ]
    ltm[ k + 1, n + 1, 5 ] <- Pm[ k, n, 3, 2 ] * lm[ k, n, 2 ]
    ltm[ k + 1, n + 1, 6 ] <- Pm[ k, n, 4, 2 ] * lm[ k, n, 2 ]
    ltm[ k + 1, n + 1, 7 ] <- Pm[ k, n, 5, 2 ] * lm[ k, n, 2 ]
    ltm[ k + 1, n + 1, 8 ] <- Pm[ k, n, 6, 2 ] * lm[ k, n, 2 ]
    ltm[ k + 1, n + 1, 9 ] <- Pm[ k, n, 3, 3 ] * lm[ k, n, 3 ]
    ltm[ k + 1, n + 1, 10 ] <- Pm[ k, n, 6, 3 ] * lm[ k, n, 3 ]
    ltm[ k + 1, n + 1, 11 ] <- Pm[ k, n, 4, 4 ] * lm[ k, n, 4 ]
    ltm[ k + 1, n + 1, 12 ] <- Pm[ k, n, 6, 4 ] * lm[ k, n, 4 ]
    ltm[ k + 1, n + 1, 13 ] <- Pm[ k, n, 5, 5 ] * lm[ k, n, 5 ]
    ltm[ k + 1, n + 1, 14 ] <- Pm[ k, n, 6, 5 ] * lm[ k, n, 5 ]    
    
  }
}

# Transformación proyección a data.table -----------------------------------------------------------
message( '\tCreando data.table con población proyectada y conteos de transición' )
pob_proy <- NULL
tau <- c( tau_f, tau_m )
for ( n in 1:N ) {
  lx <- rbind( lf[ , n, ], lm[ , n, ] )
  ltx <- rbind( ltf[ , n, ], ltm[ , n, ] )
  
  lx <- data.table( t = t[ n ],
                    sexo = rep( c( 'F', 'M' ), each = M ), 
                    x = rep( x, 2 ), 
                    l = lx,
                    lt = ltx,
                    tau = tau )
  
  setnames( lx, c( 't', 'sexo', 'x', 
                   paste0( 'l', 1:6 ), 
                   paste0( 'l', c( '11',
                                   '12',
                                   '16',
                                   '22',
                                   '23',
                                   '24',
                                   '25',
                                   '26',
                                   '33',
                                   '36',
                                   '44',
                                   '46',
                                   '55',
                                   '56') ), 
                   'tau' ) )
  
  pob_proy <- rbind( pob_proy, lx )
  
}
#Calcular el número de afiliados activos y cesantes-------------------------------------------------
pob_proy[ , l2_cot := tau * l2 ]
pob_proy[ , l2_ces := ( 1 - tau ) * l2 ]



#Calcular el estado de pensionistas de rentas vitalicias de incapacidad permanente parcial----------
p77<- data.table( sexo = c(rep('F',106),rep('M',106)),
                  x = c(0:105,0:105) ,
                  p77 = c(Pf[,1,5,5],Pm[,1,5,5]) ) # probailidad de supervivencia de los PP, PT y PA
pop_ini_7 <- pob_ini_rtr[ estado == 'PP' , list( sexo, x, l = lx ) ]
aux <-  merge(p77, pop_ini_7, by.x = c("sexo","x"), 
              by.y = c("sexo","x"), all.x = TRUE, all.y = FALSE)

aux_m<-aux[sexo=='M']
aux_m<-aux_m[,list(x,p77,l)]
aux_m<-cbind(data.matrix(aux_m),matrix(0, 106, N-1))

aux_f<-aux[sexo=='F']
aux_f<-aux_f[,list(x,p77,l)]
aux_f<-cbind(data.matrix(aux_f),matrix(0, 106, N-1))

for (i in 1:(M-1)) {
  for (j in 1:(N-1)) {
    aux_m[i+1,j+3] <- aux_m[i,j+2] * aux_m[i,2]
    aux_f[i+1,j+3] <- aux_f[i,j+2] * aux_f[i,2]
}
}

aux<-rbind(aux_f,aux_m)

aux<-as.data.table(cbind(sexo=c(rep('F',106),rep('M',106)),as.data.table(aux)))
aux<-as.data.table(gather(as_tibble(aux),t, l7, c(4:44)))
setorder(aux, x,sexo)
aux[,t:=c(rep(0:(N-1),212))]
aux<-aux[,list(sexo,x,t,l7)]

pob_proy <- merge(pob_proy, aux, by.x = c("sexo","x","t"),
                  by.y = c("sexo","x","t"), all.x = TRUE, all.y = FALSE)

#Calcular la transición l76-------------------------------------------------------------------------
p76<- data.table( sexo = c(rep('F',106),rep('M',106)),
                  x = c(0:105,0:105) ,
                  p76 = c(Pf[,1,6,5],Pm[,1,6,5]) ) # probailidad de supervivencia de los PP, PT y PA
aux <-  merge(aux,p76, by.x = c("sexo","x"), 
              by.y = c("sexo","x"), all.x = TRUE, all.y = FALSE)
aux[,l76:=lag(p76)*lag(l7)]
aux<-aux[,list(sexo,x,t,l76)]
pob_proy <- merge(pob_proy, aux, by.x = c("sexo","x","t"),
                  by.y = c("sexo","x","t"), all.x = TRUE, all.y = FALSE)

pob_proy[t==0,l76:=0]
#Calcular beneficiarios de indemnizaciones de incapacidad permanente parcial------------------------
pob_proy<-merge(pob_proy,sin_ind,by=c("x","sexo"),all.x = TRUE,all.y = FALSE)
pob_proy <- pob_proy[ is.na(tasa_sin_indem_int) ,tasa_sin_indem_int:=0 ]
pob_proy[ , l8 := l2_cot*tasa_sin_indem_int ] 
pob_proy[,tasa_sin_indem_int:=NULL]

#Estimación del número de subsidios-----------------------------------------------------------------
pob_proy<-merge(pob_proy,sin_sub,by=c("x","sexo"),all.x = TRUE,all.y = FALSE)
pob_proy <- pob_proy[ is.na(tasa_sin_sub_int) ,tasa_sin_sub_int:=0 ]
pob_proy[ , l_11 := l2_cot*tasa_sin_sub_int ] 
pob_proy[,tasa_sin_sub_int:=NULL]

#Estimación de accidentes laborales fatales por año-------------------------------------------------
message( '\tEstimación de accidentes laborales fatales por año' )
pob_proy<-merge(pob_proy,incidencia_FA[,list(x=edad,
                                             tasa_FA=exp(log_tasa_inc_FA_int))],by=c("x"),all = TRUE)
pob_proy[ , l_FA := l2_cot*tasa_FA ]
pob_proy[ is.na( l_FA ), l_FA:=0 ]
pob_proy[,tasa_FA:=NULL]

#Estimación del número de beneficiarios de montepío por orfandad------------------------------------
message( '\tEstimación del número de beneficiarios de montepío por orfandad' )
aux<- data.table( sexo = c(rep('F',106),rep('M',106)),
                  x = c(0:105,0:105))

l9<-merge(pob_proy[ , list(t,x,sexo,l_FA) ], GF_orfandad[, list(x=edad,
                                                                    pGF_mo=pGF_orfandad_int)],by=c("x"),
            all.x = TRUE,
            all.y = FALSE)
l9[ is.na( pGF_mo ), pGF_mo:=0 ]

l9 <- l9[ , l9 := (l_FA*pGF_mo), by=c("t") ]

l9 <- l9[ , list(l9 = sum(l9)), by=c("t") ]


aux <- merge( aux, fdp_ingresos_huerfanos_edad_sexo[, list(x, sexo,
                                                                     fdp_mo=fdp_int)],by=c("x","sexo"),
                   all.x = TRUE,
                   all.y = FALSE)
aux[ is.na( fdp_mo ), fdp_mo:=0 ]

aux[x<17,ind_mo:=1]
aux[ is.na(ind_mo) , ind_mo:=0]

aux <- merge(aux, pob_ini_rtr[estado=='MO',list(x,sexo,lx)],by=c("x","sexo"),
             all.x = TRUE,
             all.y = FALSE)

aux_m<-aux[sexo=='M']
aux_m <- aux_m[,sexo:=NULL]
l9_m<-(cbind(as.matrix(aux_m),matrix(0, 106, N-1)))

aux_f<-aux[sexo=='F']
aux_f <- aux_f[,sexo:=NULL]
l9_f<-(cbind(as.matrix(aux_f),matrix(0, 106, N-1)))

for (i in 1:(M-1)) {
  for (j in 1:(N-1)) {
    l9_m[i+1,j+4] <-  l9_m[i+1,2] * as.numeric(l9[j+1,2]) + l9_m[i,3] * l9_m[i,j+3]
    l9_f[i+1,j+4] <-  l9_f[i+1,2] * as.numeric(l9[j+1,2]) + l9_f[i,3] * l9_f[i,j+3]
  }
}

l9 <- rbind(l9_f,l9_m)
l9<-as.data.table(cbind(sexo=c(rep('F',106),rep('M',106)),as.data.table(l9)))
l9<-as.data.table(gather(as_tibble(l9),t, l9, c(5:45)))
setorder(l9, x,sexo)
l9[,t:=c(rep(0:(N-1),212))]
l9<-l9[,list(sexo,x,t,l9)]

pob_proy <- merge(pob_proy, l9, by.x = c("sexo","x","t"),
                  by.y = c("sexo","x","t"), all.x = TRUE, all.y = FALSE)

#Estimación del número de beneficiarios de montepío por viudez--------------------------------------
message( '\tEstimación del número de beneficiarios de montepío por viudez' )
aux<- data.table( sexo = c(rep('F',106),rep('M',106)),
                  x = c(0:105,0:105))

l_10<-merge(pob_proy[ , list(t,x,sexo,l_FA) ], GF_viudez[, list(x=edad,
                                                                pGF_mv=pGF_viudez_int )],by=c("x"),
          all.x = TRUE,
          all.y = FALSE)
l_10[ is.na( pGF_mv ), pGF_mv:=0 ]

l_10<- l_10[ , l_10 := (l_FA*pGF_mv), by=c("t") ]

l_10 <- l_10[ , list(l_10 = sum(l_10)), by=c("t") ]


aux <- merge( aux, fdp_ingresos_viudas_edad_sexo[, list(x, sexo,
                                                           fdp_mv=fdp_int)],by=c("x","sexo"),
              all.x = TRUE,
              all.y = FALSE)
aux[ is.na( fdp_mv ), fdp_mv:=0 ]

aux <- merge(aux, pob_ini_rtr[estado=='MV',list(x,sexo,lx)],by=c("x","sexo"),
             all.x = TRUE,
             all.y = FALSE)

aux_m<-aux[sexo=='M']
aux_m <- aux_m[,sexo:=NULL]
l_10_m<-(cbind(as.matrix(aux_m),matrix(0, 106, N-1)))

aux_f<-aux[sexo=='F']
aux_f <- aux_f[,sexo:=NULL]
l_10_f<-(cbind(as.matrix(aux_f),matrix(0, 106, N-1)))


for (i in 1:(M-1)) {
  for (j in 1:(N-1)) {
    l_10_m[i+1,j+3] <-  l_10_m[i+1,2] * as.numeric(l_10[j+1,2]) + l_10_m[i,j+2] * (1-as.numeric(Pm[ i, j+1, 6, 3 ]))
    l_10_f[i+1,j+3] <-  l_10_f[i+1,2] * as.numeric(l_10[j+1,2]) + l_10_f[i,j+2] * (1-as.numeric(Pf[ i, j+1, 6, 3 ]))
  }
}

l_10 <- rbind(l_10_f,l_10_m)
l_10<-as.data.table(cbind(sexo=c(rep('F',106),rep('M',106)),as.data.table(l_10)))
l_10<-as.data.table(gather(as_tibble(l_10),t, l_10, c(4:44)))
setorder(l_10, x,sexo)
l_10[,t:=c(rep(0:(N-1),212))]
l_10<-l_10[,list(sexo,x,t,l_10)]

pob_proy <- merge(pob_proy, l_10, by.x = c("sexo","x","t"),
                  by.y = c("sexo","x","t"), all.x = TRUE, all.y = FALSE)
#Agrupar beneficiarios por año y sexo---------------------------------------------------------------
message( '\tAgrupar beneficiarios por año y sexo' )
pob_proy_tot <- pob_proy[, list( l1 = sum( l1 ),
                                 l2 = sum( l2 ),
                                 l3 = sum( l3 ),
                                 l4 = sum( l4 ),
                                 l5 = sum( l5 ),
                                 l6 = sum( l6 ),
                                 l7 = sum( l7 ),
                                 l8 = sum( l8 ),
                                 l9 = sum( l9 ),
                                 l_10 = sum( l_10 ),
                                 l_11 = sum( l_11 ),
                                 l_FA = sum( l_FA ),
                                 l2_cot = sum( l2_cot ),
                                 l2_ces = sum( l2_ces ),
                                 l11 = sum( l11 ),
                                 l12 = sum( l12 ),
                                 l16 = sum( l16 ),
                                 l22 = sum( l22 ),
                                 l23 = sum( l23 ),
                                 l24 = sum( l24 ), 
                                 l25 = sum( l25 ),
                                 l26 = sum( l26 ),
                                 l33 = sum( l33 ),
                                 l36 = sum( l36 ),
                                 l44 = sum( l44 ),
                                 l46 = sum( l46 ),
                                 l55 = sum( l55 ),
                                 l56 = sum( l56 ),
                                 l76 = sum( l76 )),
                         by = list( t ) ]


pob_proy_tot_sex <- pob_proy[, list( l1 = sum( l1 ),
                                     l2 = sum( l2 ),
                                     l3 = sum( l3 ),
                                     l4 = sum( l4 ),
                                     l5 = sum( l5 ),
                                     l6 = sum( l6 ),
                                     l7 = sum( l7 ),
                                     l8 = sum( l8 ),
                                     l9 = sum( l9 ),
                                     l_10 = sum( l_10 ),
                                     l_11 = sum( l_11 ),
                                     l_FA = sum( l_FA ),
                                     l2_cot = sum( l2_cot ),
                                     l2_ces = sum( l2_ces ),
                                     l11 = sum( l11 ),
                                     l12 = sum( l12 ),
                                     l16 = sum( l16 ),
                                     l22 = sum( l22 ),
                                     l23 = sum( l23 ),
                                     l24 = sum( l24 ), 
                                     l25 = sum( l25 ),
                                     l26 = sum( l26 ),
                                     l33 = sum( l33 ),
                                     l36 = sum( l36 ),
                                     l44 = sum( l44 ),
                                     l46 = sum( l46 ),
                                     l55 = sum( l55 ),
                                     l56 = sum( l56 ),
                                     l76 = sum( l76 )), 
                             by = list( t, sexo ) ]

#Guaradar en un data frame--------------------------------------------------------------------------
message( '\tGuardando proyección de población' )
save( lf, lm, ltf, ltm, pob_proy,pob_proy_tot_sex,pob_proy_tot,
      file = paste0( parametros$RData_seg, 'IESS_RTR_proy_beneficarios_prestacion.RData' ) )

#Limpiar memoria------------------------------------------------------------------------------------
message( paste( rep('-', 100 ), collapse = '' ) )
rm( list = ls()[ !( ls() %in% c( parametros_lista, 'parametros' ) ) ] )
gc()
