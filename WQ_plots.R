InfToNA <- function(minVar) {
  ifelse(is.infinite(minVar)  , NA, minVar)
}

# All database data
Table <- function(data) {
  WQ.overall <- data %>%
  group_by(StationCode) %>%
  summarize(min.temp = min(WaterTemperature, na.rm=T),
            max.temp = max(WaterTemperature, na.rm=T),
            min.Conductivity = min(Conductivity, na.rm=T),
            max.Conductivity = max(Conductivity,na.rm=T),
            min.SPC = min(SpCnd,na.rm=T),
            max.SPC = max(SpCnd,na.rm=T),
            min.Secchi = min(Secchi,na.rm=T),
            max.Secchi = max(Secchi,na.rm=T),
            min.Turbidity = min(Turbidity,na.rm=T),
            max.Turbidity = max(Turbidity,na.rm=T),
            min.pH = min(pH,na.rm=T),
            max.pH = max(pH,na.rm=T),
            min.DO = min(DO,na.rm=T),
            max.DO = max(DO,na.rm=T),
            n = n()) %>%
    mutate_all(., InfToNA) 
  }

# Yearly boxplot, y = variable of interest
Yearbox <-  function(data,y) {
  y <- enquo(y)
  data %>%
    ggplot() +
    geom_boxplot(mapping = aes(factor(Year),!! y,fill = StationCode)) +
    theme_bw() + 
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.border = element_blank(),
          axis.line = element_line(colour = "black"),
          plot.title = element_text(hjust=0.5),
          axis.text = element_text(size = 11), 
          axis.text.x = element_text(angle = 90, hjust = 1),
          axis.title = element_text(size = 12),
          legend.text = element_text(size = 11),
          legend.position = "bottom")
}

# Monthly boxplot, y = variable of interest
Monthbox <-  function(data,y) {
  y <- enquo(y)
  data %>%
    ggplot() +
    geom_boxplot(mapping = aes(MonthAbb,!! y,fill = StationCode)) +
    theme_bw() + 
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.border = element_blank(),
          axis.line = element_line(colour = "black"),
          plot.title = element_text(hjust=0.5),
          axis.text = element_text(size = 11), 
          axis.text.x = element_text(angle = 90, hjust = 1),
          axis.title = element_text(size = 12),
          legend.text = element_text(size = 11),
          legend.position = "bottom")
}

# Point plot by date. Y = Variable of interest
VisPoint <-  function(data,y) {
  y <- enquo(y)
  data %>%
    ggplot() +
    geom_point(mapping = aes(Datetime,!! y,col = StationCode, text = paste("SampleID:", SampleID, "StationCode:", StationCode)), size = 0.5) +
    theme_bw() +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.border = element_blank(),
          axis.line = element_line(colour = "black"),
          plot.title = element_text(hjust=0.5),
          axis.text = element_text(size = 11), 
          axis.text.x = element_text(angle = 90, hjust = 1),
          axis.title = element_text(size = 12),
          legend.text = element_text(size = 11),
          legend.position = "bottom")
} 

# Histogram by Station, y = variable of interest, binwidth
VisHist <-  function(data,y, bin) {
  y <- enquo(y)
  data %>%
    ggplot() +
    geom_histogram(mapping = aes(!! y,col = StationCode),binwidth = bin, fill = "lightseagreen", colour = "lightgray") +
    facet_wrap(~StationCode, scales = "free_x") +
    theme_bw() +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.border = element_blank(),
          axis.line = element_line(colour = "black"),
          plot.title = element_text(hjust=0.5),
          axis.text = element_text(size = 11), 
          axis.text.x = element_text(angle = 90, hjust = 1),
          axis.title = element_text(size = 12),
          legend.text = element_text(size = 11))
} 

# Plot date vs. variable of interest, specifically for Lisbon
PlotVars <- function(data,y) {
  y <- enquo(y)
  data %>%
    ggplot() +
    geom_point(mapping = aes(Datetime,!! y, col = StationCode)) +
    theme_bw() +
    #scale_colour_manual(values = c("#F3B2FF", "#106E83", "#FFC971", "#BAFF87")) + 
    theme(panel.grid.major = element_blank(),
          panel.border = element_blank(),
          axis.line = element_line(colour = "black"),
          plot.title = element_text(hjust=0.5),
          axis.text = element_text(size = 11), 
          axis.text.x = element_text(angle = 90, hjust = 1),
          axis.title = element_text(size = 12),
          legend.text = element_text(size = 11))
}