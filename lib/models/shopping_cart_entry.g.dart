// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_cart_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShoppingCartEntryAdapter extends TypeAdapter<ShoppingCartEntry> {
  @override
  final int typeId = 0;

  @override
  ShoppingCartEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShoppingCartEntry(
      quantity: fields[0] as int,
      product: fields[1] as Product,
    );
  }

  @override
  void write(BinaryWriter writer, ShoppingCartEntry obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.quantity)
      ..writeByte(1)
      ..write(obj.product);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShoppingCartEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
