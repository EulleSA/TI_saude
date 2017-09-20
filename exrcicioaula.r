require(rvest) # importa a biblioteca rvest
cidades<-read_html("http://cidades.ibge.gov.br/download/mapa_e_municipios.php?lang=&uf=rn") %>% html_table(fill=TRUE)

library(stringr) #importa a biblioteca stringr
base<-data.frame(cidades[[1]][c(1,2,4)]) # Selecionando os dados de interesse
row.names(base)<-1:168 # Enumerando as linhas
base$pop2010<-str_replace_all(base$pop2010,"\\.","") # Retira os pontos
base$pop2010<-as.numeric(base$pop2010) # Converte os caracteres em numéricos
base[is.na(base)] <- 0 # Substitui valores Nas por zeros
head(base) # lista as primeiras linhas do dataframe base


#carregando o arquivo dataframe
library(sp)
setwd("/home/eulle/Documentos/") # Define o diretório de trabalho

br <- readRDS("BRA_adm2.rds") # Importa os polígonos do arquivo no diretório de trabalho

plot(br)

rn = (br[br$NAME_1=="Rio Grande do Norte",]) # Filtrando apenas os municípios do RN

plot(rn)

plot(rn[rn$NAME_2=="Natal",], add=T, col="red")

rn <- merge(x=rn, y=base, by.x="NAME_2", by.y="cidade") # Faz um merge dos dataframes
head(rn)

col_no = as.factor(as.numeric(cut(rn$pop2010.x, breaks = c(0,3000,10000,100000,300000,500000,800000,1000000), labels=c("<3k", "3k-10k", "10k-100k","100k-300k", "300k-500k", "500k-800k", ">800k"), right= FALSE)))
levels(col_no) = c("<3k", "3k-10k", "10k-100k","100k-300k", "300k-500k", "500k-800k",">800k")

rn$col_no = col_no



