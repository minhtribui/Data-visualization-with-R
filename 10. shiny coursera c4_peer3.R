---
title: "Peer Review Three"
output: 
  flexdashboard::flex_dashboard:
    orientation: columns
    vertical_layout: fill
runtime: shiny
---

```{r setup, include=FALSE}
library(flexdashboard)
library(tidyverse)
library(plotly)
library(shiny)

dat<-read_csv(url("https://www.dropbox.com/s/4ebgnkdhhxo5rac/cel_volden_wiseman%20_coursera.csv?raw=1"))

dat$Party<-recode(dat$dem,`1`="Democrat",`0`="Republican")


#######HINT: for Chart D, you'll need to set the height of the renderPlot, using the height argument. Try a value of 750.

#####some data management functions are already included. You need to add the visualization functions.

```


Page 1
======

### Chart A


```{r}
dat %>% 
  drop_na() %>% 
  filter(year>1979) %>% 
  group_by(year,Party) %>% 
  summarise(passed=sum(all_pass)) %>% 


```


Page 2 {data-orientation=columns}
=====================================
Column
-------    

### Chart B

```{r}

ggplotly(dat%>%
  drop_na()%>%
  filter(congress==110) %>%
  ggplot(aes(x=votepct,y=all_pass,
               color=Party,
               ))+
  geom_point()+
  labs(x="Vote Pct.",y="All Pass", title="Passage and Vote Pct., 110th Congress")+
  scale_color_manual(values=c("blue","red")) + geom_smooth(formula = y ~ x, method = lm)
)

```
Column
-------       
### Chart C

```{r}
ggplotly(dat%>%
  drop_na()%>%
  filter(congress==110) %>%
   ggplot(aes(x=dwnom1,y=all_pass,
               color=Party,
               ))+
  geom_point()+
  labs(x="DW Nominate.",y="All Pass", title="Passage and Ideology, 110th Congress")+
  scale_color_manual(values=c("blue","red")) + geom_smooth(formula = y ~ x, method= lm) 

)
```

Page 3  
=====================================

Input{.sidebar}
----------------------------------------------------------------
### User Input

```{r}

selectInput("states", label="States", 
           
        choices=c("AK","AL","AR","AZ","CA", "CO",
                      "CT","DE","FL","GA","HI", "IA",
                      "ID","IL","IN","KS","KY", "LA",
                      "MA","MD","ME","MI","MN", "MO",
                      "MS","MT","NC","ND","NE", "NH",
                      "NJ","NM","NV","NY","OH", "OK",
                      "OR","PA","RI","SC","SD", "TN",
                      "TX","UT","VA","VT","WA", "WI",
                      "WV","WY"),
               selected=c("AK","AL","AR","AZ","CA", "CO",
                      "CT","DE","FL","GA","HI", "IA",
                      "ID","IL","IN","KS","KY", "LA",
                      "MA","MD","ME","MI","MN", "MO",
                      "MS","MT","NC","ND","NE", "NH",
                      "NJ","NM","NV","NY","OH", "OK",
                      "OR","PA","RI","SC","SD", "TN",
                      "TX","UT","VA","VT","WA", "WI",
                      "WV","WY"),
                multiple = T
        )
 

```


Column 
----------------------------------------------------------------

### Chart D

```{r}

####hint: this figure uses selectInput with the multiple option set to true and with the options set up so that all states are initially selected.


pp<-dat %>% 
  group_by(st_name) %>% 
  filter(congress==110) %>%
  summarise(passed=sum(all_pass))



renderPlot(height=750, {
    ggplot(filter(pp,st_name %in% input$states), aes(x=passed, y=st_name))+
            geom_bar(stat="identity") +
    ggtitle("Total Bill Passed by State Delegation, 110 Congress") +
      xlab("Total Bills Passed Per State")+
      ylab("State Name")
  }
  )
    
```

