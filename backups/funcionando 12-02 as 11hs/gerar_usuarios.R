library(shiny)
library(xlsx)
library(readxl)

# Gerando registros fictícios
set.seed(123)
n = 25
ficticios <- data.frame(
  ID = 1:n,
  email = paste0(sample(letters, n), "@", sample(c("gmail", "yahoo", "hotmail"), 1), ".com"),
  nome = sample( c("Pedro", "Ana", "Felipe", "Carla", "Lucas"), n, replace = TRUE),
  leito = sample(c("", "001", "002", "003"), n, replace = TRUE),
  partida = sample(c("Pronto Socorro", "Enfermaria 1", "Enfermaria 2", "UTI", "Centro Cirúrgico"), n, replace=TRUE),
  destino = sample(c("EXAMES", "TRANSFERÊNCIA", "ALTA-ACOMPANHAMENTO", "ASSISTENCIAL", "ÓBITO-ACOMPANHAMENTO", "ASSISTENCIAL"), n, replace = TRUE),
  tipoexame = sample(c("Raio-x", "Hemograma", "Tomografia", "Ressonância", "Ultrassom"), n, replace = TRUE),
  transporte = sample(c("CADEIRA", "MACA", "CAMA", "BERÇO", "DEAMBULANDO"), n, replace = TRUE),
  meiotransporte = sample(c("SIM", "NÃO, MAQUEIRO PROVIDENCIAR"), n, replace = TRUE),
  condicoes = sample(c("PRECAUÇÃO DE CONTATO - MAQUEIRO PARAMENTAR", "PRECAUÇÃO RESPIRATÓRIA - MAQUEIRO PARAMENTAR", "EM USO DE O2- NECESSITA DE ACOMPANHAMENTO ASSISTENCIAL"), n, replace = TRUE),
  prioridades = sample(c("VERMELHO (IMEDIATO) - PCR, HEMORRAGIAS, CONVULSÕES, DOR NO PEITO, ETC.", "LARANJA (10 MIN) - DOR SEVERA MUITO SEVERA, ARRITMIA, CEFALÉIA DE RÁPIDA PROGRESSÃO", "AMARELA (URGENTE) - VÔMITOS, DESMAIOS, DORES MODERADAS, SINAIS VITAIS ALTERADOS, ETC.", "VERDE (POUCO URGENTE) - DORES LEVES, TONTURAS, RESFRIADOS, NÁUSEAS, ETC.", "AZUL (NÃO URGENTE) - DORES CRÔNICAS JÁ DIAGNOSTICADAS, ETC."), n, replace = TRUE),
  preparado = sample(c("SIM", "NÃO"), n, replace = TRUE),
  solicitante = sample(c("Médico", "Enfermeiro", "Familiar", "Paciente", "Outro"), n, replace = TRUE),
  contato = paste0("9", sample(1:9, n, replace = TRUE)),

  observacoes = sample(c("Nenhuma", "Nenhuma", "Paciente agitado", "Necessita acompanhamento", "Dor abdominal"), n, replace = TRUE)
                )

write.xlsx(ficticios, "responses/pacientes1.xlsx", row.names = FALSE)
