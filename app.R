library(shiny)
library(readxl)
library(xlsx)
library(DT)
getwd()
#setwd("D:/MAQUEIRO_COM")
ui <- navbarPage(
  "MAQUEIRO.COM",
  tabPanel("SolicitarTransporte",
             sidebarPanel(
             textInput("email", "E-mail*"),
             textInput("nome", "Nome do Paciente*"),
             textInput("leito", "Leito (opcional)"),
             textInput("partida", "Local de Partida*"),
             selectInput("destino", "Local de Destino*", choices = c("", "EXAMES", "TRANSFERÊNCIA", "ALTA- ACOMPANHAMENTO", "ASSISTENCIAL", "ÓBITO- ACOMPANHAMENTO", "ASSISTENCIAL")),
             textInput("tipoexame", "Qual Tipo de Exame?*"),
             selectInput("transporte", "Tipo de Transporte*", choices = c("", "CADEIRA", "MACA", "CAMA", "BERÇO", "DEAMBULANDO")),
             selectInput("meiotransporte", "Possui Meio de Transporte no Local?*", choices = c("", "SIM", "NÃO, MAQUEIRO PROVIDENCIAR")),
             selectInput("condicoes", "Condições do Paciente*", choices = c("", "PRECAUÇÃO DE CONTATO - MAQUEIRO PARAMENTAR", "PRECAUÇÃO RESPIRATÓRIA - MAQUEIRO PARAMENTAR", "EM USO DE O2- NECESSITA DE ACOMPANHAMENTO ASSISTENCIAL")),
             selectInput("prioridades", "Classificação de Prioridades de acordo com o Protocolo de Manchester*", choices = c("", "VERMELHO (IMEDIATO) - PCR, HEMORRAGIAS, CONVULSÕES, DOR NO PEITO, ETC.", "LARANJA (10 MIN) - DOR SEVERA MUITO SEVERA, ARRITMIA, CEFALÉIA DE RÁPIDA PROGRESSÃO", "AMARELA (URGENTE) - VÔMITOS, DESMAIOS, DORES MODERADAS, SINAIS VITAIS ALTERADOS, ETC.", "VERDE (POUCO URGETE) - DORES LEVES, TONTURAS, RESFRIADOS, NÁUSEAS, ETC.", "AZUL (NÃO URGENTE) - DORES CRÔNICAS JÁ DIAGNOSTICADAS, ETC.")),
             selectInput("preparado", "Paciente Preparado para o Transporte?*", choices = c("", "SIM", "NÃO")),
             textInput("solicitante", "Quem Solicitou o Transporte?*"),
             textInput("contato", "Ramal ou Telefone?*"),
             textInput("observacoes", "Observações (opcional)"),
             actionButton("cadastrar", "Cadastrar"),
             width = 3
           ),
           mainPanel(
             tags$div(style = "text-align: center;", tags$img(src = "https://www.gov.br/ebserh/pt-br/hospitais-universitarios/regiao-sudeste/hc-ufu/logos/hc-ufu-assinatura.png", width = "400px")),
             br(),
             h2("SolicitarTransporte"),
             span("Utilize aba para solicitar um transporte de paciente"),
             br(),
             h4("Listagem de todos os pacientes:"),
             DT::dataTableOutput("table")
           )
  ),
  tabPanel("ExcluirCadastro",
           sidebarPanel(
             selectInput("id_excluir", "ID", choices = c(1:500)),
             verbatimTextOutput("nome_excluir"),
             verbatimTextOutput("leito_excluir"),
             verbatimTextOutput("partida_excluir"),
             verbatimTextOutput("destino_excluir"),
             actionButton("excluir", "Excluir Cadastro"),
             width = 3
           ),
           mainPanel(
             tags$div(style = "text-align: center;", tags$img(src = "https://www.gov.br/ebserh/pt-br/hospitais-universitarios/regiao-sudeste/hc-ufu/logos/hc-ufu-assinatura.png", width = "400px")),
             br(),
             h2("ExcluirCadastro"),
             span("Utilize aba para deletar permanentemente uma linha do banco de dados"),
             br(),
             h4("Listagem de todos os pacientes:"),
             DT::dataTableOutput("table_excluir")
           ) ),
  
  tabPanel("IniciarTransporte",
           sidebarPanel(
             selectInput("id_iniciar_t", "ID", choices = c(1:500)),
             verbatimTextOutput("nome_iniciar_t"),
             verbatimTextOutput("leito_iniciar_t"),
             verbatimTextOutput("partida_iniciar_t"),
             verbatimTextOutput("destino_iniciar_t"),
             actionButton("iniciar_t", "Iniciar Transporte"),
             width = 3
           ),
           mainPanel(
             tags$div(style = "text-align: center;", tags$img(src = "https://www.gov.br/ebserh/pt-br/hospitais-universitarios/regiao-sudeste/hc-ufu/logos/hc-ufu-assinatura.png", width = "400px")),
             br(),
             h2("IniciarTransporte"),
             span("Utilize aba para sinalizar que INICIOU o transporte de um paciente"),
             br(),
             h4("Listagem de todos os pacientes que INICIARAM o transporte & ainda NÃO TERMINARAM"),
             DT::dataTableOutput("table_iniciar_t"),
             br(),
             h4("Listagem de todos os pacientes:"),
             DT::dataTableOutput("table2"),
           ) ),
  
  tabPanel("DarBaixaTransporte",
           sidebarPanel(
             selectInput("id_baixar_t", "ID", choices = c(1:500)),
             verbatimTextOutput("nome_baixar_t"),
             verbatimTextOutput("leito_baixar_t"),
             verbatimTextOutput("partida_baixar_t"),
             verbatimTextOutput("destino_baixar_t"),
             actionButton("baixar_t", "Baixa no Transporte"),
             width = 3
           ),
           mainPanel(
             tags$div(style = "text-align: center;", tags$img(src = "https://www.gov.br/ebserh/pt-br/hospitais-universitarios/regiao-sudeste/hc-ufu/logos/hc-ufu-assinatura.png", width = "400px")),
             br(),
             h2("DarBaixaTransporte"),
             span("Utilize aba para sinalizar que FINALIZOU o transporte de um paciente"),
             br(),
             h4("Listagem de todos os pacientes que FINALIZARAM o transporte"),
             DT::dataTableOutput("table_baixar_t"),
             br(),
             h4("Listagem de todos os pacientes que INICIARAM o transporte & ainda NÃO TERMINARAM"),
             DT::dataTableOutput("table_iniciar_t2"),
           ) ),
  
)

server <- function(input, output, session) {
  # leitura do arquivo de pacientes
  pacientes <- read_excel("responses/pacientes1.xlsx", col_types = "text")
  pacientes$ID <- as.numeric(pacientes$ID) # converte coluna ID para numérica
  
  # leitura do arquivo de pacientes para excluir
  pacientes_excluir <- read_excel("responses/pacientes1.xlsx", col_types = "text")
  pacientes_excluir$ID <- as.numeric(pacientes_excluir$ID) # converte coluna ID para numérica
  
  # leitura do arquivo de pacientes para excluir
  pacientes_iniciar_t <- read_excel("responses/pacientes1.xlsx", col_types = "text")
  pacientes_iniciar_t$ID <- as.numeric(pacientes_iniciar_t$ID) # converte coluna ID para numérica
  
  # leitura do arquivo de pacientes para excluir
  pacientes_baixar_t <- read_excel("responses/pacientes1.xlsx", col_types = "text")
  pacientes_baixar_t$ID <- as.numeric(pacientes_baixar_t$ID) # converte coluna ID para numérica
  
  

  updateSelectInput(session, "id_excluir", choices = order(pacientes_excluir$ID) )  
  
  
  
  updateSelectInput(session, "id_iniciar_t", choices = order(pacientes_iniciar_t$ID[   pacientes_iniciar_t$iniciou_transp==FALSE & pacientes_baixar_t$finalizou_transp==FALSE  ] )  )

  
  updateSelectInput(session, "id_baixar_t", choices = order(pacientes_baixar_t$ID[   pacientes_baixar_t$iniciou_transp==TRUE & pacientes_baixar_t$finalizou_transp==FALSE  ] )  )
  
  
  observeEvent(input$cadastrar, {
    # cria um novo paciente com as informações inseridas no sidebar
    novo_paciente <- data.frame(
      ID = max(pacientes$ID) + 1, # id+1
      email = input$email,
      nome = input$nome,
      leito = input$leito,
      partida = input$partida,
      destino = input$destino,
      tipoexame = input$tipoexame,
      transporte = input$transporte,
      meiotransporte = input$meiotransporte,
      condicoes = input$condicoes,
      prioridades = input$prioridades,
      preparado = input$preparado,
      solicitante = input$solicitante,
      contato = input$contato,
      observacoes = input$observacoes,
      data_cadastro = format(Sys.time(), format = '%d/%m/%Y %H:%M:%S'),
      iniciou_transp = FALSE,
      data_ini_transp = "",
      finalizou_transp = FALSE,
      data_fim_transp = ""
    )
    # adiciona o novo paciente à tabela de pacientes
    pacientes <- rbind(pacientes, novo_paciente)
    # salva a tabela atualizada no arquivo xlsx
    write.xlsx(data.frame(pacientes), "responses/pacientes1.xlsx", row.names = FALSE)
    # recarrega a aplicação
    session$reload()
  })
  
  # renderização da tabela com DT::renderDataTable
  output$table <- DT::renderDataTable({
    DT::datatable(
      pacientes, options = list(
        pageLength = 100,
        lengthMenu = c(200, 300, 500),
        orderClasses = TRUE,
        order = list(0, "desc")
      ),
      filter = 'top',
      extensions = c('Buttons', 'Scroller'),
      class = 'display',
      rownames = FALSE, # não mostra as linhas da tabela
      width = '100%'
    ) %>%
      DT::formatStyle(
        columns = 2:15,
        #backgroundColor = 'lightblue',
        fontWeight = 'bold',
        target = 'cell'
      )
  })
  
  
  
  # renderizando_outra_tabela_principal igual a table
  output$table2 <- DT::renderDataTable({
    DT::datatable(
      pacientes, options = list(
        pageLength = 100,
        lengthMenu = c(200, 300, 500),
        orderClasses = TRUE,
        order = list(0, "desc")
      ),
      filter = 'top',
      extensions = c('Buttons', 'Scroller'),
      class = 'display',
      rownames = FALSE, # não mostra as linhas da tabela
      width = '100%'
    ) %>%
      DT::formatStyle(
        columns = 2:15,
        #backgroundColor = 'lightblue',
        fontWeight = 'bold',
        target = 'cell'
      )
  })
  
  
  output$table_excluir <- DT::renderDataTable({
    DT::datatable(
      pacientes_excluir, options = list(
        pageLength = 100,
        lengthMenu = c(200, 300, 500),
        orderClasses = TRUE,
        order = list(0, "desc")
      ),
      filter = 'top',
      extensions = c('Buttons', 'Scroller'),
      class = 'display',
      rownames = FALSE, # não mostra as linhas da tabela
      width = '100%'
    ) %>%
      DT::formatStyle(
        columns = 2:15,
        #backgroundColor = 'lightblue',
        fontWeight = 'bold',
        target = 'cell'
      )
  })
  
  output$table_iniciar_t <- DT::renderDataTable({
    dados_temp <- data.frame(pacientes_iniciar_t)[data.frame(pacientes_iniciar_t)$iniciou_transp == TRUE,]
    dados_temp <- dados_temp[dados_temp$finalizou_transp == FALSE,]
    
    DT::datatable(
      dados_temp, 
      options = list(
        pageLength = 100,
        lengthMenu = c(200, 300, 500),
        orderClasses = TRUE,
        order = list(0, "desc")
      ),
      filter = 'top',
      extensions = c('Buttons', 'Scroller'),
      class = 'display',
      rownames = FALSE, # não mostra as linhas da tabela
      width = '100%'
    ) %>%
      DT::formatStyle(
        columns = 2:15,
        #backgroundColor = 'lightblue',
        fontWeight = 'bold',
        target = 'cell'
      )
  })

  
  output$table_iniciar_t2 <- DT::renderDataTable({
    #tratamento dos dados
    dados_temp <- data.frame(pacientes_iniciar_t)[data.frame(pacientes_iniciar_t)$iniciou_transp == TRUE,]
    dados_temp <- dados_temp[dados_temp$finalizou_transp == FALSE,]
    
    DT::datatable(
      dados_temp
      , options = list(
        pageLength = 100,
        lengthMenu = c(200, 300, 500),
        orderClasses = TRUE,
        order = list(0, "desc")
      ),
      filter = 'top',
      extensions = c('Buttons', 'Scroller'),
      class = 'display',
      rownames = FALSE, # não mostra as linhas da tabela
      width = '100%'
    ) %>%
      DT::formatStyle(
        columns = 2:15,
        #backgroundColor = 'lightblue',
        fontWeight = 'bold',
        target = 'cell'
      )
  })
  
  output$table_baixar_t <- DT::renderDataTable({
    DT::datatable(
        data.frame(pacientes_baixar_t)[data.frame(pacientes_baixar_t)$finalizou_transp == TRUE,], 
        options = list(
        pageLength = 100,
        lengthMenu = c(200, 300, 500),
        orderClasses = TRUE,
        order = list(0, "desc")
      ),
      filter = 'top',
      extensions = c('Buttons', 'Scroller'),
      class = 'display',
      rownames = FALSE, # não mostra as linhas da tabela
      width = '100%'
    ) %>%
      DT::formatStyle(
        columns = 2:15,
        #backgroundColor = 'lightblue',
        fontWeight = 'bold',
        target = 'cell'
      )
  })

  
  observeEvent(input$id_excluir, {
    dados_paciente_excluir <- pacientes_excluir[pacientes_excluir$ID == input$id_excluir, ]
    output$nome_excluir <- renderText({ dados_paciente_excluir$nome })
    output$leito_excluir <- renderText({ dados_paciente_excluir$leito })
    output$lpartida_excluir <- renderText({ dados_paciente_excluir$partida })
    output$destino_excluir <- renderText({ dados_paciente_excluir$destino })

  })
  
  observeEvent(input$id_iniciar_t, {
    dados_paciente_iniciar_t <- pacientes_excluir[pacientes_iniciar_t$ID == input$id_iniciar_t, ]
    output$nome_iniciar_t <- renderText({ dados_paciente_iniciar_t$nome })
    output$leito_iniciar_t <- renderText({ dados_paciente_iniciar_t$leito })
    output$lpartida_iniciar_t <- renderText({ dados_paciente_iniciar_t$partida })
    output$destino_iniciar_t <- renderText({ dados_paciente_iniciar_t$destino })
    
  })
  
  
  observeEvent(input$id_baixar_t, {
    dados_paciente_baixar_t <- pacientes_excluir[pacientes_baixar_t$ID == input$id_baixar_t, ]
    output$nome_baixar_t <- renderText({ dados_paciente_baixar_t$nome })
    output$leito_baixar_t <- renderText({ dados_paciente_baixar_t$leito })
    output$lpartida_baixar_t <- renderText({ dados_paciente_baixar_t$partida })
    output$destino_baixar_t <- renderText({ dados_paciente_baixar_t$destino })
    
  })
  
  
  # exclui o paciente da base de dados
  observeEvent(input$excluir, {
    pacientes_excluir <- pacientes_excluir[pacientes$ID != input$id_excluir, ]
    write.xlsx(data.frame(pacientes_excluir), "responses/pacientes1.xlsx", row.names = FALSE)
    session$reload()
  })
  
  # Inicia o Transporte
  observeEvent(input$iniciar_t, {
    pacientesiniciar_t_editando <- pacientes_iniciar_t[pacientes$ID == input$id_iniciar_t, ]
    pacientesiniciar_t_guarda_outros <- pacientes_iniciar_t[pacientes$ID != input$id_iniciar_t, ]
    
    pacientesiniciar_t_editando$iniciou_transp = TRUE
    pacientesiniciar_t_editando$data_ini_transp = format(Sys.time(), format = '%d/%m/%Y %H:%M:%S')
    pacientesiniciar_t_editando$finalizou_transp = FALSE
    pacientesiniciar_t_editando$data_fim_transp =""
    pacientesiniciar_t_guardar <-  rbind(pacientesiniciar_t_guarda_outros , pacientesiniciar_t_editando)

    write.xlsx(data.frame(pacientesiniciar_t_guardar), "responses/pacientes1.xlsx", row.names = FALSE)
    session$reload()
  })
  

  # Baixar Transporte
  observeEvent(input$baixar_t, {
    pacientesbaixar_t_editando <- pacientes_baixar_t[pacientes$ID == input$id_baixar_t, ]
    pacientesbaixar_t_guarda_outros <- pacientes_baixar_t[pacientes$ID != input$id_baixar_t, ]
    
    pacientesbaixar_t_editando$finalizou_transp = TRUE
    pacientesbaixar_t_editando$data_fim_transp = format(Sys.time(), format = '%d/%m/%Y %H:%M:%S')
    pacientesbaixar_t_guardar <-  rbind(pacientesbaixar_t_guarda_outros , pacientesbaixar_t_editando)
    
    write.xlsx(data.frame(pacientesbaixar_t_guardar), "responses/pacientes1.xlsx", row.names = FALSE)
    session$reload()
  })
  
  
  
  }

shinyApp(ui = ui, server = server)