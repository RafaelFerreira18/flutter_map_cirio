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
    LatLng(-1.4537, -48.5027),
    LatLng(-1.4537, -48.5005),
    LatLng(-1.4538, -48.4980),
    LatLng(-1.4538, -48.4955),
    LatLng(-1.4542, -48.4933),
    LatLng(-1.4555, -48.4910),
    LatLng(-1.4562, -48.4898),
    LatLng(-1.4568, -48.4889),
  ];

  // ── Rota da Trasladação (Sábado) ──────────────────────────────────────────
  // Desde 1988, o percurso é o mesmo do Círio em sentido inverso:
  // Basílica de Nazaré → Av. Nazaré → Praça da República
  //   → Av. Presidente Vargas → Catedral da Sé
  static const List<LatLng> rotaTrasladacao = [
    LatLng(-1.4568, -48.4889),
    LatLng(-1.4562, -48.4898),
    LatLng(-1.4555, -48.4910),
    LatLng(-1.4542, -48.4933),
    LatLng(-1.4538, -48.4955),
    LatLng(-1.4538, -48.4980),
    LatLng(-1.4537, -48.5005),
    LatLng(-1.4537, -48.5027),
  ];

  static const String osrmBase =
      'https://router.project-osrm.org/route/v1/foot';
}
