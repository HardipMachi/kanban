import 'package:go_router/go_router.dart';
import 'package:kanban/features/auth/presentation/screens/login_screen.dart';
import 'package:kanban/features/auth/presentation/screens/register_screen.dart';
import 'package:kanban/features/kanban/presentation/screens/kanban_screen.dart';
import 'package:kanban/app/app_routes/app_route_names.dart';

final appRouter = GoRouter(
  initialLocation: AppRouteNames.login,
  routes: [
    GoRoute(
      path: AppRouteNames.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRouteNames.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRouteNames.kanban,
      builder: (context, state) => const KanbanScreen(),
    ),
  ],
);
