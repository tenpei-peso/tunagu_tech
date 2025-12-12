// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import '../../../domain/budget/entities/category.dart';
import '../../../domain/budget/entities/entry.dart';
import '../../../domain/budget/entities/household.dart';
import '../../../domain/budget/entities/tag.dart';
import '../../../domain/budget/entities/todo.dart';

DateTime asDateTime(dynamic value) {
  if (value is Timestamp) {
    return value.toDate();
  }
  if (value is DateTime) {
    return value;
  }
  throw ArgumentError('Unsupported date value: $value');
}

Entry entryFromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
  final data = doc.data();
  return Entry(
    id: doc.id,
    bookId: data['bookId'] as String,
    type: EntryType.values.byName(data['type'] as String),
    amount: (data['amount'] as num).toInt(),
    dateTime: asDateTime(data['dateTime']),
    categoryId: data['categoryId'] as String,
    tagIds: List<String>.from(data['tagIds'] as List<dynamic>? ?? []),
    purchaseTagId: data['purchaseTagId'] as String?,
    memo: data['memo'] as String?,
    createdBy: data['createdBy'] as String,
    createdAt: asDateTime(data['createdAt']),
    updatedAt: asDateTime(data['updatedAt']),
  );
}

Map<String, dynamic> entryToDoc(Entry entry) {
  return <String, dynamic>{
    'bookId': entry.bookId,
    'type': entry.type.name,
    'amount': entry.amount,
    'dateTime': Timestamp.fromDate(entry.dateTime),
    'categoryId': entry.categoryId,
    'tagIds': entry.tagIds,
    'purchaseTagId': entry.purchaseTagId,
    'memo': entry.memo,
    'createdBy': entry.createdBy,
    'createdAt': Timestamp.fromDate(entry.createdAt),
    'updatedAt': Timestamp.fromDate(entry.updatedAt),
  };
}

Category categoryFromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
  final data = doc.data();
  return Category(
    id: doc.id,
    bookId: data['bookId'] as String,
    name: data['name'] as String,
    iconName: data['iconName'] as String,
    colorValue: data['colorValue'] as int,
    isDefault: (data['isDefault'] as bool?) ?? false,
    createdAt: asDateTime(data['createdAt']),
    updatedAt: asDateTime(data['updatedAt']),
  );
}

Map<String, dynamic> categoryToDoc(Category category) {
  return <String, dynamic>{
    'bookId': category.bookId,
    'name': category.name,
    'iconName': category.iconName,
    'colorValue': category.colorValue,
    'isDefault': category.isDefault,
    'createdAt': Timestamp.fromDate(category.createdAt),
    'updatedAt': Timestamp.fromDate(category.updatedAt),
  };
}

Tag tagFromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
  final data = doc.data();
  return Tag(
    id: doc.id,
    bookId: data['bookId'] as String,
    name: data['name'] as String,
    iconName: data['iconName'] as String,
    colorValue: data['colorValue'] as int,
    type: TagType.values.byName(data['type'] as String),
    createdAt: asDateTime(data['createdAt']),
    updatedAt: asDateTime(data['updatedAt']),
  );
}

Map<String, dynamic> tagToDoc(Tag tag) {
  return <String, dynamic>{
    'bookId': tag.bookId,
    'name': tag.name,
    'iconName': tag.iconName,
    'colorValue': tag.colorValue,
    'type': tag.type.name,
    'createdAt': Timestamp.fromDate(tag.createdAt),
    'updatedAt': Timestamp.fromDate(tag.updatedAt),
  };
}

Todo todoFromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
  final data = doc.data();
  return Todo(
    id: doc.id,
    bookId: data['bookId'] as String,
    categoryId: data['categoryId'] as String,
    title: data['title'] as String,
    dueDate: asDateTime(data['dueDate']),
    isDone: data['isDone'] as bool,
    createdAt: asDateTime(data['createdAt']),
    updatedAt: asDateTime(data['updatedAt']),
  );
}

Map<String, dynamic> todoToDoc(Todo todo) {
  return <String, dynamic>{
    'bookId': todo.bookId,
    'categoryId': todo.categoryId,
    'title': todo.title,
    'dueDate': Timestamp.fromDate(todo.dueDate),
    'isDone': todo.isDone,
    'createdAt': Timestamp.fromDate(todo.createdAt),
    'updatedAt': Timestamp.fromDate(todo.updatedAt),
  };
}

Household householdFromDoc(
  QueryDocumentSnapshot<Map<String, dynamic>> doc,
) {
  final data = doc.data();
  return Household(
    id: doc.id,
    name: data['name'] as String,
    memberIds: List<String>.from(data['memberIds'] as List<dynamic>),
    createdAt: asDateTime(data['createdAt']),
    updatedAt: asDateTime(data['updatedAt']),
  );
}

Map<String, dynamic> householdToDoc(Household household) {
  return <String, dynamic>{
    'name': household.name,
    'memberIds': household.memberIds,
    'createdAt': Timestamp.fromDate(household.createdAt),
    'updatedAt': Timestamp.fromDate(household.updatedAt),
  };
}
