library(shiny)
library(readxl)
library(xlsx)
library(DT)

ui <- fluidPage(
  sidebarLayout(
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
      selectInput("prioridades", "Classificação de Prioridades de acordo com o Protocolo de Manchester*", choices = c("", "VERMELHO (IMEDIATO) - PCR, HEMORRAGIAS, CONVULSÓES, DOR NO PEITO, ETC.", "LARANJA (10 MIN) - DOR SEVERA MUITO SEVERA, ARRITMIA, CEFALÉIA DE RÁPIDA PROGRESSÃO", "AMARELA (URGENTE) - VÔMITOS, DESMAIOS, DORES MODERADAS, SINAIS VITAIS ALTERADOS, ETC.", "VERDE (POUCO URGETE) - DORES LEVES, TONTURAS, RESFRIADOS, NÁUSEAS, ETC.", "AZUL (NÃO URGENTE) - DORES CRÔNICAS JÁ DIAGNOSTICADAS, ETC.")),
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
      downloadButton("downloadData", "Download"),
      DT::dataTableOutput("table")
    )
  )
)
server <- function(input, output, session) {
  # leitura do arquivo de pacientes
  pacientes <- read_excel("responses/pacientes1.xlsx", col_types = "text")
  pacientes$ID <- as.numeric(pacientes$ID) # converte coluna ID para numérica
  
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
      observacoes = input$observacoes
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
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("data", ".xlsx", sep = "")
    },
    content = function(file) {
      # converter os dados para xlsx e salvar o arquivo
      write.xlsx(pacientes, file, row.names = FALSE)
    }
  )
}




shinyApp(ui = ui, server = server)