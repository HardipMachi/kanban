// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 's.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

  @override
  String get welcome => 'Welcome';

  @override
  String get loginSubHeading => 'Login to continue to Kanban Board';

  @override
  String get loginSuccess => 'Login Successful';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Login';

  @override
  String get registerPrompt => 'Don\'t have an account? Register';

  @override
  String get appTitle => 'Flutter Kanban App';

  @override
  String get createAccount => 'Create Account';

  @override
  String get register => 'Register';

  @override
  String get registerSuccess => 'Registered Successfully';

  @override
  String get registerToStart => 'Register to get started with Kanban Board';

  @override
  String get registerName => 'Full Name';

  @override
  String get alreadyHaveAccount => 'Already have an account? Login';

  @override
  String get kanbanTitle => 'Kanban Board';

  @override
  String get logout => 'Logged out successfully';

  @override
  String get taskDelete => 'Task deleted successfully';

  @override
  String get fillDetail => 'Please fill all fields';

  @override
  String get addTask => 'Add Task';

  @override
  String get editTask => 'Edit Task';

  @override
  String get textFieldTitle => 'Title';

  @override
  String get textFieldDesc => 'Description';

  @override
  String get cancelTextButton => 'Cancel';

  @override
  String get taskAddSuccess => 'Task added successfully';

  @override
  String get taskEditSuccess => 'Task edited successfully';

  @override
  String get add => 'Add';

  @override
  String get update => 'Update';

  @override
  String get delete => 'Delete';

  @override
  String get todo => 'todo';

  @override
  String get inProgress => 'inProgress';

  @override
  String get completed => 'completed';

  @override
  String get unexpectedError => 'Unexpected error:';

  @override
  String get logoutFailed => 'Logout failed:';

  @override
  String get noTaskYet => 'No tasks yet';

  @override
  String get todoColumnTitle => 'To Do';

  @override
  String get inProgressColumnTitle => 'In Progress';

  @override
  String get completedColumnTitle => 'Completed';
}
