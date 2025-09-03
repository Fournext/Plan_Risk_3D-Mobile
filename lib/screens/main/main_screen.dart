import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_plan_risk_3d/screens/dasboard/view/dashboard_screen.dart';
import 'package:mobile_plan_risk_3d/screens/main/ConfigOptionsCard.dart';
import 'package:mobile_plan_risk_3d/screens/main/sidebar/view/sidebar.dart';
import 'package:mobile_plan_risk_3d/screens/view/glb_viewer_page.dart';

import '../auth/service/auth_controller.dart';
import '../../routes/routes.dart';
import '../widgets/navegacion/pill_bottom_nav.dart';
import 'perfil/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _auth = Get.find<AuthController>();
  int _selectedIndex = 0;
  bool _isSidebarOpen = false;

  final List<Widget> _pages = const [
    DashboardScreen(),
    Center(child: Text('Dashboard / Estadísticas')),
    ProfileScreen(),
    Center(child: Text('Diseño IA')),
    //Center(child: Text('Configuraciones')),
   const ConfigOptionsCard()
  ];

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
      _isSidebarOpen = false;
    });
  }

  bool get _isMobile => MediaQuery.of(context).size.width < 600;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _isMobile
          ? Drawer(
              child: Sidebar(
                selectedIndex: _selectedIndex,
                onItemSelected: _onItemSelected,
                onLogout: () {
                  _auth.logout();
                  Get.offAllNamed(AppRoutes.signin);
                },
              ),
            )
          : null,
      body: Row(
        children: [
          if (!_isMobile)
            Sidebar(
              selectedIndex: _selectedIndex,
              onItemSelected: _onItemSelected,
              onLogout: () {
                _auth.logout();
                Get.offAllNamed(AppRoutes.signin);
              },
            ),
          Expanded(
            child: Column(
              children: [
                if (_isMobile)
                  SafeArea(
                    bottom: false,
                    child: Container(
                      height: 64,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFF8F0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Builder(
                            builder: (context) => IconButton(
                              icon: const Icon(Icons.menu),
                              onPressed: () => Scaffold.of(context).openDrawer(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Plan Risk 3D',
                              style: TextStyle(
                                color: Color(0xFF202020),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Viewer 3D',
                            onPressed: () => Get.to(() => const GlbViewerPage()),
                            icon: const Icon(Icons.view_in_ar),
                            color: Color(0xFF475569),
                          ),
                          IconButton(
                            tooltip: 'Perfil',
                            onPressed: () => _onItemSelected(2),
                            icon: const Icon(Icons.person),
                            color: Color(0xFF475569),
                          ),
                          IconButton(
                            tooltip: 'Logout',
                            onPressed: () {
                              _auth.logout();
                              Get.offAllNamed(AppRoutes.signin);
                            },
                            icon: const Icon(Icons.logout),
                            color: Color(0xFFEF4444),
                          ),
                        ],
                      ),
                    ),
                  ),
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: _pages,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _isMobile
          ? PillBottomNav(index: _selectedIndex, onTap: _onItemSelected)
          : null,
    );
  }
}
