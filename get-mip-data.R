# get MIP-data for Germany from Forschungsgruppe Wahlen
src <- "https://www.forschungsgruppe.de/Umfragen/Politbarometer/Langzeitentwicklung_-_Themen_im_Ueberblick/Politik_II/9_Probleme_1_1.xlsx"
lcl <- paste0(getwd(), "/data/", basename(src))

# prepare folder for data, if not already done
if (!dir.exists(paste0(getwd(), "/data"))) {
  dir.create(paste0(getwd(), "/data"))
}

if (!file.exists(lcl)) {
  download.file(url = src, destfile = lcl, mode = "wb")
}

# read into R
mip <- readxl::read_excel(lcl, skip = 7, col_types = c("date", rep("numeric", 6)))
head(mip)

names(mip)[1] <- "date"

issues <- names(mip)[-1]


mip_scaled <- mip[,1]

for (issue in 2:(length(issues)+1)) {
  mip_scaled[,issue] <- mip[,issue] / max(mip[,issue], na.rm = T)*100
}


mip_scaled_long <- pivot_longer(mip_scaled, cols = -date, names_to = "issue", values_to = "index")

# clean up
rm(mip, mip_scaled, issue, issues, lcl, src)

save(mip_scaled_long, file = "./data/MIP-Data.RData")
