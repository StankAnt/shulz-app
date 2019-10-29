import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final int id;

  Post({this.id}) : super([id]);

  @override
  String toString() => 'Shulz { id: $id }';
}
