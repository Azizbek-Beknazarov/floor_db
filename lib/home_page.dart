import 'package:flutter/material.dart';

import 'db/dao/person_dao.dart';
import 'db/database.dart';
import 'db/entity/person.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PersonDao _productDao = AppDatabase.instance!.personDao;
  TextEditingController _nameController = TextEditingController();
  bool isUpdate = false;
  int updateID = -1;
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notebook")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _productDao.people(),
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  final List<Person> peopleName = snapshot.data as List<Person>;
                  return ListView.separated(
                    itemBuilder: (_, index) {
                      return ListTile(
                        onTap: () {
                          _nameController.text = peopleName[index].name;
                          isUpdate = true;
                          updateID = peopleName[index].id;
                          myFocusNode.requestFocus();
                          setState(() {});
                        },
                        title: Text(peopleName[index].name),
                        trailing: IconButton(
                          onPressed: () async {
                            await _productDao.deletePerson(peopleName[index]);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      );
                    },
                    separatorBuilder: (_, index) {
                      return const Divider();
                    },
                    itemCount: peopleName.length,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          TextField(
            focusNode: myFocusNode,
            controller: _nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Name",
            ),
          )
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: MediaQuery.of(context).viewInsets,
        child: ElevatedButton(
          onPressed: () async {
            if (!isUpdate) {
              if (_nameController.text.trim().isEmpty) return;
              final id = (await _productDao.findAllPeople()).length;
              await _productDao.insertPerson(
                Person(id + 1, _nameController.text.trim()),
              );
            } else {
              if (_nameController.text.trim().isEmpty) return;
              await _productDao
                  .updatePerson(Person(updateID, _nameController.text.trim()));
              isUpdate = false;
            }
            _nameController.clear();
          },
          child: isUpdate ? Text("Update") : Text("Add"),
        ),
      ),
    );
  }
}
