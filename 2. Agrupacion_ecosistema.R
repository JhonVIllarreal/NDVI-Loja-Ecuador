rm(list = ls())

#Lectura de la matriz NDVI filtrada
load("C:/Users/jhonv/Documents/Loja/Loja/NDVI_row.RData")

#Lectura de información de los ecosistemas
Ubicacion_vegetacion <- read.table("C:/Users/jhonv/Documents/Loja/Loja/Puntos_general.txt",sep = ",", header = T)

#Creación de la matriz de NDVI con respecto a los ecosistemas
NDVI_Veg <- NDVI[as.numeric(Ubicacion_vegetacion$RASTERVALU),]

#Se crea un vector con los códigos de los ecosistemas 
Vegetaciones <- unique(as.numeric(Ubicacion_vegetacion$grid_code))

#Se realiza el conteo de los pixeles por cada vegetación
Pixeles.vegetacion <- sapply(1:length(Vegetaciones), function(x){length(Porcentaje.data[Ubicacion_vegetacion$RASTERVALU[Ubicacion_vegetacion$grid_code == Vegetaciones[x]]])})

#Se calcula el porcentaje de información de cada pixel con cambio de nombres de columnas y filas
Porcentaje.vegetacion <- sapply(1:length(Vegetaciones), function(y){
  sapply(seq(0,0.95,0.05), function (x) {
    round(sum(Porcentaje.data[Ubicacion_vegetacion$RASTERVALU[Ubicacion_vegetacion$grid_code == Vegetaciones[y]]] > x)/Pixeles.vegetacion[y],4)})  
})
colnames(Porcentaje.vegetacion) <- Vegetaciones
rownames(Porcentaje.vegetacion) <- seq(0,0.95,0.05)

#Creación de matriz de porcentajes y ecosistemas con cambio de nombres de columnas y filas
pixel.vegetacion <- sapply(1:length(Vegetaciones), function(y){
  sapply(seq(0,0.95,0.05), function (x) {
    round(sum(Porcentaje.data[Ubicacion_vegetacion$RASTERVALU[Ubicacion_vegetacion$grid_code == Vegetaciones[y]]] > x),4)})  
})
colnames(pixel.vegetacion) <- Vegetaciones
rownames(pixel.vegetacion) <- seq(0,0.95,0.05)