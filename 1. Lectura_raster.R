# EL SIGUIENTE SCRIPT FUE ESCRITO PARA LECTURA DE RASTER DESCARGADO DE GOOGLE ENGINE DE NDVI Y SQA DE MODIS PARA LA PROVINCIA DE LOJA
# SE DESCARGA LOS RASTER DE NDVI Y SQA SON DESCARGADOS EN LA CARPETA DE PROYECTO DE LA CUAL SE PROCEDE A REALIZAR EL FILTRADO DE CALIDAD DE DATOS
# FINALMENTE SE CREA UNA MATRIZ DE NDVI CON LA INFORMACIÓN FILTRADA
# FECHA: 6 DE JUNIO 2023
# AUTOR: JHON A. VILLARREAL

library(raster)

#Selección de la carpeta donde se encuentran las imágenes MODIC y SQA
setwd("C:/Users/jhonv/Documents/Loja/MODIS")

#Guarda la cantidad de archivos existentes en la carpeta (debe ser un número par)
Archivos <- length(list.files())/2

#Guarda todos los nombres de las imágenes
Nombres <- list.files()

#Creación de vectores vacíos para guardar los raster tanto de NDVI y SQA
row_NDVI <- vector("list", Archivos)
row_QA <- vector("list", Archivos)

#Lectura de los raster y cambio de coordenadas a WGS84 UTM 17S
row_NDVI <- sapply(1:Archivos,function (x){projectRaster(raster(Nombres[x]), crs = "+proj=utm +zone=17 +south +ellps=WGS84 +datum=WGS84 +units=m +no_defs ")})
row_QA <- sapply((Archivos+1):(Archivos*2), function (x){projectRaster(raster(Nombres[x]), crs = "+proj=utm +zone=17 +south +ellps=WGS84 +datum=WGS84 +units=m +no_defs ")})

#Creación de matrices en la que se tiene en las filas los pixeles y en las columnas los datos de NDVI mensuales

NDVI <- matrix(nrow = length(values(row_NDVI[[1]])), ncol = Archivos)
QA <- matrix(nrow = length(values(row_NDVI[[1]])), ncol = Archivos)

#Matriz de posición de todo el raster
Ubicacion.pixel <- cbind(xyFromCell(row_NDVI[[1]], 1:ncell(row_NDVI[[1]])), values(row_NDVI[[1]]))

#De raster a matrices
for (i in 1:Archivos) {
  NDVI[,i] <- values(row_NDVI[[i]])
  QA[,i] <- values(row_QA[[i]])*10000
}

#Eliminación de información con valores de SQA de 2 y 3
NDVI[QA > 1] <- NA

#Creación de un archivo *.RData de NDVI
NDVI <- cbind(matrix(NA,nrow = nrow(NDVI)),NDVI)
save(NDVI,file="C:/Users/jhonv/Documents/Loja/Loja/NDVI_row.RData")