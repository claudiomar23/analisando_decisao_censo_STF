library(readxl)
library(readr)
library(NLP)
library(tm)
library(RColorBrewer)
library(wordcloud)
library(wordcloud2)
library(pdftools)

textos = VCorpus(DirSource("Arquivos",
                           encoding="UTF-8"),readerControl = list(reader=readPDF,language="por"))

textos1 <- textos
inspect(textos)

textos = tm_map(textos, content_transformer(tolower))
textos = tm_map(textos, removeWords,stopwords('portuguese'))
textos = tm_map(textos, stripWhitespace)
textos = tm_map(textos, removePunctuation)
textos = tm_map(textos, removeNumbers)
vetor_correção <- c("supremo","federal","tribunal", "documento",
                    "ser","página","art","sob","acórdão","conforme","pode",
                    "teor","código","assinado","endereço","inteiro",
                    "procuradorgeral","voto","httpwwwstfjusbrportalautenticacaoautenticardocumentoasp",
                    "senha","aco","ministro","ainda","relator","especial"
                    , "censos","originária","ano","vogal","pre","procuradoria")
textos = tm_map(textos, removeWords,vetor_correção)

tdm = TermDocumentMatrix(textos)
m = as.matrix(tdm)
v = sort(rowSums(m),decreasing=TRUE)

d = data.frame(word = names(v),freq=v)
head(d, 50)
e <- head(d,50)

wordcloud(words = d$word, freq = d$freq, min.freq = 28,
          max.words=200, random.order = T, rot.per=0.5, 
          colors = brewer.pal(8, "Dark2"))

write.csv2(e,"50_palavras_mais_usadas.csv")
