# 9-1-2019 MRC-Epid JHZ

options(scipen=20, width=200)

# collate all Credible sets
cs <- data.frame()
wd <- Sys.getenv("wd")
stbed <- read.table(file.path(wd,"st.bed"),as.is=TRUE,header=TRUE)
for(i in seq(nrow(stbed)))
{
  r <- paste0("chr",stbed[i,1],"_",stbed[i,2],"_",stbed[i,3])
  f <- paste0(r,".cs")
  if(file.exists(f))
  {
    t <- read.table(f,as.is=TRUE,header=TRUE)
    cs <- rbind(cs,data.frame(region=r,t))
  }
}

# split snpid
cs <- within(cs, {
   sp <- lapply(lapply(snpid, function(x) strsplit(x,":|_")),unlist)
   Chr <- Pos <- NA
})

# obtain positions
cs <- within(cs, {
   for(i in seq(nrow(cs))) {
      Chr[i] <- as.integer(sp[[i]][1])
      Pos[i] <- as.integer(sp[[i]][2])
   }
})

# order by positions
ord <- with(cs, order(Chr,Pos))
cs <- within(cs[ord,],{i <- ssnpid <- sp <- NULL})
write.table(cs, file="jam.cs", row.names=FALSE, quote=FALSE)
