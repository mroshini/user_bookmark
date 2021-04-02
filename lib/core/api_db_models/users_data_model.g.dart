// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UsersListAdapter extends TypeAdapter<UsersList> {
  @override
  final int typeId = 0;

  @override
  UsersList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UsersList(
      (fields[0] as List)?.cast<User>(),
    );
  }

  @override
  void write(BinaryWriter writer, UsersList obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.users);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsersListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 1;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      login: fields[0] as String,
      avatarUrl: fields[2] as String,
      bookMarkStatus: fields[1] as bool,
      id: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.login)
      ..writeByte(1)
      ..write(obj.bookMarkStatus)
      ..writeByte(2)
      ..write(obj.avatarUrl)
      ..writeByte(3)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
