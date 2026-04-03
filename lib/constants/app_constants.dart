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
  // Catedral da Sé → Av. Presidente Vargas → Praça da República
  //   → Av. Nazaré → Basílica de Nazaré
  static const List<LatLng> rotaCirio = [
    LatLng(-1.4537, -48.5027), // Catedral da Sé — Início
    LatLng(-1.4537, -48.5005), // Av. Presidente Vargas (saída da Sé)
    LatLng(-1.4538, -48.4980), // Av. Presidente Vargas
    LatLng(-1.4538, -48.4955), // Praça da República
    LatLng(-1.4542, -48.4933), // Av. Presidente Vargas (após Praça)
    LatLng(-1.4555, -48.4910), // Av. Nazaré — início da descida sul
    LatLng(-1.4562, -48.4898), // Av. Nazaré
    LatLng(-1.4568, -48.4889), // Basílica de Nazaré — Fim
  ];

  // ── Rota da Trasladação (Sábado) ──────────────────────────────────────────
  // Desde 1988, o percurso é o mesmo do Círio em sentido inverso:
  // Basílica de Nazaré → Av. Nazaré → Praça da República
  //   → Av. Presidente Vargas → Catedral da Sé
  static const List<LatLng> rotaTrasladacao = [
    LatLng(-1.4568, -48.4889), // Basílica de Nazaré — Início
    LatLng(-1.4562, -48.4898), // Av. Nazaré
    LatLng(-1.4555, -48.4910), // Av. Nazaré — fim da subida norte
    LatLng(-1.4542, -48.4933), // Av. Presidente Vargas
    LatLng(-1.4538, -48.4955), // Praça da República
    LatLng(-1.4538, -48.4980), // Av. Presidente Vargas
    LatLng(-1.4537, -48.5005), // Av. Presidente Vargas (chegando à Sé)
    LatLng(-1.4537, -48.5027), // Catedral da Sé — Fim
  ];

  // ── API de roteamento (OSRM — gratuita, sem chave) ────────────────────────
  static const String osrmBase =
      'https://router.project-osrm.org/route/v1/foot';
}
