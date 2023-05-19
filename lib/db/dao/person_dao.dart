// dao/person_dao.dart

import 'package:floor/floor.dart';

import '../entity/person.dart';

@dao
abstract class PersonDao {
  @Query('SELECT * FROM Person')
  Future<List<Person>> findAllPeople();

  @Query('SELECT * FROM Person')
  Stream<List<Person>> people();

  @Query('SELECT name FROM Person')
  Stream<List<String>> findAllPeopleName();

  @Query('SELECT * FROM Person WHERE id = :id')
  Stream<Person?> findPersonById(int id);

  @insert
  Future<void> insertPerson(Person person);

  @delete
  Future<void> deletePerson(Person person);
  @update
  Future<void> updatePerson(Person person);
}
