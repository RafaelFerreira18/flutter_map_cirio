import 'package:latlong2/latlong.dart';

class AppConstants {
  // ── Pontos fixos ──────────────────────────────────────────────────────────
  /// Catedral da Sé — ponto de início do Círio de Nazaré
  static const LatLng pontoInicial = LatLng(-1.4537, -48.5027);

  /// Basílica de Nossa Senhora de Nazaré — destino da procissão
  static const LatLng basilica = LatLng(-1.4568, -48.4889);

  // ── Câmera inicial ────────────────────────────────────────────────────────
  static const LatLng centroMapa = LatLng(-1.4552, -48.4958);
  static const double zoomInicial = 14.0;

  // ── Rota do Círio de Nazaré (Domingo) ─────────────────────────────────────
  // Catedral da Sé → Rua Sen. Manoel Barata → Praça da República
  //   → Av. Presidente Vargas → Av. Nazaré → Basílica de Nazaré
  static const List<LatLng> rotaCirio = [
    LatLng(-1.4537, -48.5027), // Catedral da Sé — Início
    LatLng(-1.4541, -48.5003), // Rua Senador Manoel Barata
    LatLng(-1.4545, -48.4978), // Praça da República
    LatLng(-1.4549, -48.4953), // Av. Presidente Vargas
    LatLng(-1.4552, -48.4929), // Av. Presidente Vargas
    LatLng(-1.4555, -48.4908), // início Av. Nazaré
    LatLng(-1.4562, -48.4897), // Av. Nazaré
    LatLng(-1.4568, -48.4889), // Basílica de Nazaré — Fim
  ];

  // ── Rota da Trasladação (Sábado) ──────────────────────────────────────────
  // Basílica de Nazaré → Av. Generalíssimo Deodoro
  //   → Av. Assis de Vasconcelos → Catedral da Sé
  static const List<LatLng> rotaTrasladacao = [
    LatLng(-1.4568, -48.4889), // Basílica de Nazaré — Início
    LatLng(-1.4552, -48.4903), // Av. Generalíssimo Deodoro
    LatLng(-1.4532, -48.4925), // Av. Generalíssimo Deodoro
    LatLng(-1.4512, -48.4952), // continuação
    LatLng(-1.4497, -48.4978), // Av. Assis de Vasconcelos
    LatLng(-1.4490, -48.5003), // continuação
    LatLng(-1.4500, -48.5019), // Largo da Sé
    LatLng(-1.4515, -48.5025), // Praça Frei Caetano Brandão
    LatLng(-1.4537, -48.5027), // Catedral da Sé — Fim
  ];

  // ── API de roteamento (OSRM — gratuita, sem chave) ────────────────────────
  static const String osrmBase =
      'https://router.project-osrm.org/route/v1/driving';
}
