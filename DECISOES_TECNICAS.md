# Decisões Técnicas — Círio de Nazaré App

## 1. Framework e Pacotes

| Pacote | Motivo da escolha |
|---|---|
| **`flutter_map`** | Biblioteca open-source para Flutter, sem necessidade de chave de API (diferente do Google Maps). Leve, flexível e bem documentada. |
| **`latlong2`** | Tipo padrão `LatLng` usado pelo `flutter_map`. Evita conversões manuais de coordenadas. |
| **`geolocator`** | Abstração multiplataforma (Android/iOS) para obter a posição GPS do usuário, já tratando o fluxo de permissões. |
| **`http`** | Cliente HTTP simples para consumir a API de roteamento OSRM. |

---

## 2. Mapa — OpenStreetMap + OSRM

- O tile layer usa **OpenStreetMap** (`tile.openstreetmap.org`) — gratuito e sem cadastro.
- A rota "Ir até o ponto inicial" consome a **API pública OSRM** (`router.project-osrm.org`), que retorna o caminho real por ruas no formato GeoJSON. Também é gratuita e sem chave de API.

---

## 3. Rotas das Procissões — Coordenadas Fixas

As rotas do **Círio** (domingo) e da **Trasladação** (sábado) são listas de `LatLng` definidas estaticamente em `app_constants.dart`. Essa decisão foi intencional:

- Os trajetos são históricos e não mudam a cada execução;
- Não depende de internet para exibir as rotas principais;
- Simplifica a manutenção — qualquer ajuste de trajeto é feito em um único arquivo.

---

## 4. Estrutura do Código

```
lib/
 ├── main.dart                  ← entry point, MaterialApp
 ├── constants/
 │   └── app_constants.dart     ← coordenadas, rotas e URLs centralizados
 ├── screens/
 │   └── home_screen.dart       ← única tela (StatefulWidget)
 └── services/
     ├── location_service.dart  ← GPS + permissões
     └── routing_service.dart   ← chamada à API OSRM
```

Separação em **services** (lógica de negócio) e **screens** (UI) mantém o código organizado e testável.

---

## 5. Permissões de Localização

`LocationService` verifica e solicita permissão em tempo de execução antes de qualquer chamada GPS, seguindo o fluxo exigido pelo Android e iOS:

1. Verifica se o serviço de localização está ativo;
2. Verifica o status da permissão;
3. Solicita permissão se ainda não concedida;
4. Retorna `null` (em vez de lançar exceção) se negada — a tela trata isso com uma mensagem de erro visível ao usuário.

---

## Como Rodar

```bash
# Instalar dependências
flutter pub get

# Rodar no emulador ou dispositivo conectado
flutter run
```

> Para Android físico: habilite **Depuração USB** nas configurações do celular.  
> Para emulador Android, a localização pode ser simulada pelo AVD Manager do Android Studio.
