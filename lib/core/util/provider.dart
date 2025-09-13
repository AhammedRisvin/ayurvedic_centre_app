import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../screens/auth/controller/auth_controller.dart';

List<SingleChildWidget> providers = [ChangeNotifierProvider(create: (_) => AuthProvider())];
