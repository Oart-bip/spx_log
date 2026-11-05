<<<<<<< HEAD
# Órbita Log — Diário de voo

Aplicativo Flutter que funciona como um diário de bordo de lançamentos espaciais: mostra o próximo lançamento com contagem de dias, a lista de missões (com filtro e busca), os foguetes mais utilizados e estatísticas gerais. Todas as informações vêm da API em tempo de execução.

## Objetivo

Trabalho acadêmico para praticar requisições HTTP, leitura de JSON, `async`/`await`, tratamento de erros e apresentação de dados de uma API REST em uma interface mobile com identidade visual própria.

## Tecnologias

- Flutter e Dart (SDK >= 3.3)
- Pacote [`http`](https://pub.dev/packages/http) (única dependência além do Flutter)

## API utilizada

- **Nome:** Launch Library 2 (The Space Devs)
- **Endereço:** https://ll.thespacedevs.com/2.2.0
- **Documentação:** https://ll.thespacedevs.com/docs/
- **Autenticação:** não é necessária no plano gratuito (limite de 15 requisições por hora)

Endpoints consumidos:

| Endpoint | Uso no app |
|---|---|
| `GET /launch/upcoming/` | próximos lançamentos e destaque da tela inicial |
| `GET /launch/previous/` | lançamentos já realizados |
| `GET /config/launcher/` | tela da frota (foguetes com mais lançamentos) |

Os textos de descrição (missões e foguetes) são fornecidos pela API em inglês.

Por causa do limite de requisições, o app guarda as respostas em memória por 10 minutos e agrupa pedidos idênticos. Puxar para atualizar força uma nova consulta (no mínimo 1 minuto após a anterior). Se o limite for atingido, o app mostra uma mensagem explicando. Para usar a versão de desenvolvimento da API (limite maior, dados mais antigos), troque `ll.` por `lldev.` em `lib/services/space_service.dart`.

## Funcionalidades

- Tela inicial com o próximo lançamento (contagem em dias), totais de missões realizadas e agendadas e descrição da missão
- Lista de missões com filtro (todos, sucesso, falha, próximos) e busca por missão, foguete ou agência
- Tela de detalhe da missão (data, hora UTC, foguete, órbita, relatório, motivo da falha e plataforma)
- Tela da frota com foto, medidas, número de lançamentos e taxa de sucesso
- Estado de carregamento, mensagens de erro (sem internet, timeout, limite da API, resposta inválida) com botão "tentar de novo" e mensagem para listas vazias
- Puxar para atualizar em todas as telas

## Identidade visual

Tema "controle de missão": fundo grafite, texto cor de osso e um único laranja de sinalização. Títulos grossos e apertados, dados e rótulos em fonte monoespaçada. Não usa AppBar, cards arredondados nem BottomNavigationBar padrão: a navegação é própria (itens numerados com barra deslizante), as listas são separadas por filetes e os indicadores ficam em linhas divididas. Algumas composições são deliberadamente assimétricas (contagem gigante à direita, imagens com recuo alternado).

## Como executar

1. Instale o [Flutter](https://docs.flutter.dev/get-started/install) e confira com `flutter doctor`.
2. Clone o repositório e entre na pasta.
3. Gere as pastas de plataforma (o repositório contém só o código do app):

   ```bash
   flutter create . --project-name spx_log
   ```

4. Para builds de release no Android, confirme que `android/app/src/main/AndroidManifest.xml` contém:

   ```xml
   <uses-permission android:name="android.permission.INTERNET"/>
   ```

5. Instale as dependências e execute:

   ```bash
   flutter pub get
   flutter run
   ```

O app precisa de conexão com a internet. O `flutter create` pode gerar `test/widget_test.dart` referenciando `MyApp`; apague esse arquivo se for rodar `flutter test`.

## Estrutura

```
lib/
  main.dart                 ponto de entrada
  models/                   Launch e Rocket (fromJson)
  services/                 SpaceService (requisições HTTP, cache e erros)
  screens/                  AppShell, Home, Missões, Detalhe, Frota
  widgets/                  navegação, filtros, linhas, indicadores, estados
  theme/                    cores e estilos de texto
  utils/                    leitura de JSON, formatação e transição de rota
```
=======

>>>>>>> 1e61cf87ff4afae4d967b409f0111796cb9598a3
