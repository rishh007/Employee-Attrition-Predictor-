# Load the shiny library
library(shiny)
library(ggplot2)
library(randomForest) 

# Load trained model
rf_model <- readRDS("rf_model.rds")

# Defined UI with added styling
ui <- fluidPage(
  tags$head(tags$style(HTML("
    body {background-color: #f7f7f7; font-family: Tahoma, sans-serif;}
    .title {color: #003366; font-weight: bold; font-family: 'Cascadia Code', monospace;}
    .sidebar {background-color: #e0f2f1; padding: 20px; border-radius: 10px;}
    .btn {background-color: #00796b; color: #fff; width: 100%;}
    .result {font-size: 36px; font-weight: bold; margin-top: 20px;}  /* Increased font size here */
    .importance {color: #00796b; font-size: 16px; margin-top: 20px;}
    .importancePlot {height: 400px; width: 100%; margin-top: 20px;}
  "))),
  
  titlePanel(div("Attrition Prediction", class = "title")),
  
  sidebarLayout(
    sidebarPanel(
      div(class = "sidebar",
          numericInput("age", "Age:", value = 30, min = 18, max = 60),
          numericInput("jobLevel", "Job Level:", value = 1, min = 1, max = 5),
          selectInput("jobRole", "Job Role:", choices = levels(dataset$JobRole)),
          selectInput("maritalStatus", "Marital Status:", choices = levels(dataset$MaritalStatus)),
          numericInput("monthlyIncome", "Monthly Income:", value = 3000, min = 1009, max = 19999),
          selectInput("overTime", "Overtime:", choices = levels(dataset$OverTime)),
          numericInput("stockOptionLevel", "Stock Option Level:", value = 0, min = 0, max = 3),
          numericInput("totalWorkingYears", "Total Working Years:", value = 5, min = 0, max = 40),
          actionButton("predict", "Predict", class = "btn")
      )
    ),
    
    mainPanel(
      div(uiOutput("result"), class = "result"),
      conditionalPanel(
        condition = "output.result !== ''",  
        plotOutput("importancePlot")  
      )
    )
  )
)

# Defined the server logic
server <- function(input, output) {
  prediction <- eventReactive(input$predict, {
    validate(
      need(input$age >= 18 && input$age <= 60, "Error: Age must be between 18 and 60."),
      need(input$jobLevel >= 1 && input$jobLevel <= 5, "Error: Job Level must be between 1 and 5."),
      need(input$monthlyIncome >= 1009 && input$monthlyIncome <= 19999, "Error: Monthly Income must be between 1009 and 19999."),
      need(input$stockOptionLevel >= 0 && input$stockOptionLevel <= 3, "Error: Stock Option Level must be between 0 and 3."),
      need(input$totalWorkingYears >= 0 && input$totalWorkingYears <= 40, "Error: Total Working Years must be between 0 and 40.")
    )
    
    new_data <- data.frame(
      Age = input$age,
      JobLevel = input$jobLevel,
      JobRole = as.factor(input$jobRole),
      MaritalStatus = as.factor(input$maritalStatus),
      MonthlyIncome = input$monthlyIncome,
      OverTime = as.factor(input$overTime),
      StockOptionLevel = input$stockOptionLevel,
      TotalWorkingYears = input$totalWorkingYears
    )
    
    new_data[, num_vars] <- predict(preProc, new_data[, num_vars])
    
    prediction <- predict(rf_model, new_data)
    
    return(prediction)
  })
  
  # Output the prediction result with dynamic color and larger font size
  output$result <- renderUI({
    req(prediction())
    pred_value <- prediction()
    
    # Check if prediction is a list, and extract the value if necessary
    if (is.list(pred_value)) {
      pred_value <- as.character(pred_value[[1]])  # Convert list to character
    }
    
    # Set color based on the prediction result
    color <- ifelse(pred_value == "Yes", "#5ccc2b", "#cc0000")
    
    # Return the prediction with dynamic color and larger font size using HTML
    HTML(paste0('<span style="color:', color, '; font-size: 36px;">Predicted Attrition: ', pred_value, '</span>'))
  })
  
  output$importancePlot <- renderPlot({
    rf_model_obj <- rf_model$finalModel  
    imp <- importance(rf_model_obj)
    
    imp_df <- data.frame(
      Variable = rownames(imp),
      Importance = imp[, 1]
    )
    
    factor_vars <- c("JobRole", "MaritalStatus", "OverTime")
    
    aggregated_imp_df <- imp_df %>%
      dplyr::mutate(MainVariable = case_when(
        grepl("JobRole", Variable) ~ "JobRole",
        grepl("MaritalStatus", Variable) ~ "MaritalStatus",
        grepl("OverTime", Variable) ~ "OverTime",
        TRUE ~ Variable
      )) %>%
      dplyr::group_by(MainVariable) %>%
      dplyr::summarize(TotalImportance = sum(Importance)) %>%
      dplyr::arrange(desc(TotalImportance))
    
    ggplot(aggregated_imp_df, aes(x = reorder(MainVariable, TotalImportance), y = TotalImportance)) +
      geom_bar(stat = "identity", fill = "#00796b") +
      coord_flip() +  
      labs(title = "Variable Importance", x = "Variables", y = "Importance") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
}

# Run the application
shinyApp(ui = ui, server = server)
