import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../constants/app_constants.dart';
import '../services/location_service.dart';
import '../services/routing_service.dart';

enum _RouteMode { none, cirio, trasladacao, minhaRota }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _mapController = MapController();

  _RouteMode _mode = _RouteMode.none;
  LatLng? _userLocation;
  List<LatLng>? _dynamicRoute;
  List<LatLng>? _cirioRoute;
  List<LatLng>? _trasladacaoRoute;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildMap(),
          if (_isLoading) _buildLoadingOverlay(),
          if (_errorMessage != null) _buildErrorBanner(),
          if (_mode != _RouteMode.none) _buildRouteInfoCard(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _centerOnUser,
        tooltip: 'Minha localização',
        backgroundColor: const Color(0xFF0D47A1),
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0D47A1),
      foregroundColor: Colors.white,
      centerTitle: true,
      title: const Column(
        children: [
          Text(
            'Círio de Nazaré',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          Text(
            'Belém do Pará',
            style: TextStyle(fontSize: 11, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: AppConstants.centroMapa,
        initialZoom: AppConstants.zoomInicial,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app_mapa',
        ),
        _buildPolylines(),
        _buildMarkers(),
        const SimpleAttributionWidget(
          source: Text('© OpenStreetMap contributors'),
        ),
      ],
    );
  }

  Widget _buildPolylines() {
    return PolylineLayer(
      polylines: [
        if (_mode == _RouteMode.cirio && _cirioRoute != null)
          Polyline(
            points: _cirioRoute!,
            color: const Color(0xFF1565C0),
            strokeWidth: 5.0,
            borderColor: const Color(0xFF0D47A1),
            borderStrokeWidth: 1.5,
          ),
        if (_mode == _RouteMode.trasladacao && _trasladacaoRoute != null)
          Polyline(
            points: _trasladacaoRoute!,
            color: const Color(0xFF2E7D32),
            strokeWidth: 5.0,
            borderColor: const Color(0xFF1B5E20),
            borderStrokeWidth: 1.5,
          ),
        if (_mode == _RouteMode.minhaRota && _dynamicRoute != null)
          Polyline(
            points: _dynamicRoute!,
            color: const Color(0xFFE65100),
            strokeWidth: 5.0,
            borderColor: const Color(0xFFBF360C),
            borderStrokeWidth: 1.5,
          ),
      ],
    );
  }

  Widget _buildMarkers() {
    return MarkerLayer(
      markers: [
        _marker(
          point: AppConstants.pontoInicial,
          icon: Icons.church,
          color: Colors.red.shade700,
          label: 'Início',
          tooltip: 'Catedral da Sé\n(Ponto inicial do Círio)',
        ),
        _marker(
          point: AppConstants.basilica,
          icon: Icons.place,
          color: Colors.purple.shade700,
          label: 'Basílica',
          tooltip: 'Basílica de Nossa Senhora de Nazaré',
        ),
        if (_userLocation != null)
          Marker(
            point: _userLocation!,
            width: 44,
            height: 44,
            child: const Tooltip(
              message: 'Você está aqui',
              child: Icon(
                Icons.person_pin_circle,
                color: Colors.blueAccent,
                size: 44,
              ),
            ),
          ),
      ],
    );
  }

  Marker _marker({
    required LatLng point,
    required IconData icon,
    required Color color,
    required String label,
    required String tooltip,
  }) {
    return Marker(
      point: point,
      width: 52,
      height: 52,
      child: Tooltip(
        message: tooltip,
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black26,
      child: const Center(
        child: Card(
          elevation: 8,
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 14),
                Text('Aguarde...'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorBanner() {
    return Positioned(
      top: 8,
      left: 12,
      right: 12,
      child: Card(
        color: Colors.red.shade50,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red.shade700),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red.shade800, fontSize: 13),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _errorMessage = null),
                child: Icon(Icons.close, color: Colors.red.shade700, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRouteInfoCard() {
    final info = _routeInfo(_mode);
    return Positioned(
      top: 8,
      left: 12,
      right: 12,
      child: Card(
        color: info.color,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Icon(info.icon, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      info.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      info.subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0D47A1),
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        children: [
          _routeButton(
            label: 'Círio',
            subtitle: 'Domingo',
            icon: Icons.directions_walk,
            activeColor: const Color(0xFF90CAF9),
            mode: _RouteMode.cirio,
          ),
          const _Divider(),
          _routeButton(
            label: 'Trasladação',
            subtitle: 'Sábado',
            icon: Icons.directions_walk,
            activeColor: const Color(0xFFA5D6A7),
            mode: _RouteMode.trasladacao,
          ),
          const _Divider(),
          _routeButton(
            label: 'Minha Rota',
            subtitle: 'GPS',
            icon: Icons.near_me,
            activeColor: const Color(0xFFFFCC80),
            mode: _RouteMode.minhaRota,
          ),
        ],
      ),
    );
  }

  Widget _routeButton({
    required String label,
    required String subtitle,
    required IconData icon,
    required Color activeColor,
    required _RouteMode mode,
  }) {
    final selected = _mode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => _toggleRoute(mode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: selected
                ? activeColor.withOpacity(0.22)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: selected
                ? Border.all(color: activeColor, width: 1.5)
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: selected ? activeColor : Colors.white54,
                size: 24,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: selected ? activeColor : Colors.white54,
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: selected
                      ? activeColor.withOpacity(0.8)
                      : Colors.white30,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _toggleRoute(_RouteMode mode) async {
    if (_mode == mode) {
      setState(() {
        _mode = _RouteMode.none;
        _dynamicRoute = null;
        _errorMessage = null;
      });
      _mapController.move(AppConstants.centroMapa, AppConstants.zoomInicial);
      return;
    }

    setState(() {
      _mode = mode;
      _errorMessage = null;
      _dynamicRoute = null;
    });

    switch (mode) {
      case _RouteMode.cirio:
        await _loadStaticRoute(
          AppConstants.rotaCirio,
          (route) => _cirioRoute = route,
        );
      case _RouteMode.trasladacao:
        await _loadStaticRoute(
          AppConstants.rotaTrasladacao,
          (route) => _trasladacaoRoute = route,
        );
      case _RouteMode.minhaRota:
        await _loadUserRoute();
      case _RouteMode.none:
        break;
    }
  }

  Future<void> _loadStaticRoute(
    List<LatLng> waypoints,
    void Function(List<LatLng>) setRoute,
  ) async {
    setState(() => _isLoading = true);

    final route = await RoutingService.getRouteMultiWaypoint(waypoints);

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (route != null && route.isNotEmpty) {
      setState(() => setRoute(route));
      _fitPoints(route);
    } else {
      // Fallback: usa os pontos originais se a API falhar
      setState(() => setRoute(waypoints));
      _fitPoints(waypoints);
    }
  }

  Future<void> _loadUserRoute() async {
    setState(() => _isLoading = true);

    final userPos = await LocationService.getCurrentLocation();

    if (!mounted) return;

    if (userPos == null) {
      setState(() {
        _isLoading = false;
        _mode = _RouteMode.none;
        _errorMessage =
            'Não foi possível obter sua localização.\n'
            'Verifique se o GPS está ativado e as permissões concedidas.';
      });
      return;
    }

    setState(() => _userLocation = userPos);

    final route = await RoutingService.getRoute(
      userPos,
      AppConstants.pontoInicial,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (route == null || route.isEmpty) {
      setState(() {
        _mode = _RouteMode.none;
        _errorMessage =
            'Não foi possível calcular a rota.\n'
            'Verifique sua conexão com a internet.';
      });
      return;
    }

    setState(() => _dynamicRoute = route);
    _fitPoints([userPos, ...route]);
  }

  Future<void> _centerOnUser() async {
    setState(() => _isLoading = true);
    final pos = await LocationService.getCurrentLocation();
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (pos != null) {
      setState(() => _userLocation = pos);
      _mapController.move(pos, 15.0);
    } else {
      setState(() {
        _errorMessage =
            'Não foi possível obter sua localização.\n'
            'Verifique se o GPS está ativado.';
      });
    }
  }

  void _fitPoints(List<LatLng> points) {
    if (points.isEmpty) return;
    try {
      final bounds = LatLngBounds.fromPoints(points);
      _mapController.fitCamera(
        CameraFit.bounds(
          bounds: bounds,
          padding: const EdgeInsets.fromLTRB(48, 80, 48, 130),
        ),
      );
    } catch (_) {
      _mapController.move(points.first, 14.0);
    }
  }

  _InfoData _routeInfo(_RouteMode mode) {
    switch (mode) {
      case _RouteMode.cirio:
        return _InfoData(
          title: 'Procissão do Círio de Nazaré',
          subtitle: 'Catedral da Sé → Basílica de Nazaré  •  ~3,6 km',
          color: const Color(0xFF1565C0),
          icon: Icons.directions_walk,
        );
      case _RouteMode.trasladacao:
        return _InfoData(
          title: 'Trasladação',
          subtitle: 'Basílica de Nazaré → Catedral da Sé  •  ~3,8 km',
          color: const Color(0xFF2E7D32),
          icon: Icons.directions_walk,
        );
      case _RouteMode.minhaRota:
        return _InfoData(
          title: 'Minha Rota até o Ponto Inicial',
          subtitle: 'Sua localização → Catedral da Sé (Círio)',
          color: const Color(0xFFE65100),
          icon: Icons.near_me,
        );
      case _RouteMode.none:
        return _InfoData(
          title: '',
          subtitle: '',
          color: Colors.transparent,
          icon: Icons.place,
        );
    }
  }
}

class _InfoData {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  const _InfoData({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
  });
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 1,
      height: 40,
      child: VerticalDivider(color: Colors.white24, width: 1),
    );
  }
}
