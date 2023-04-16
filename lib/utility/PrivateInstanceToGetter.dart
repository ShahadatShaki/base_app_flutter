void main() {

  var v = "String? _id;  String? _date;  String? _count";
  var variabls = v.split(';');
//   print(variabls.length);
//   print(variabls);
  for (int i = 0; i < variabls.length ; i++) {
//     print(variabls[i]);
    variabls[i] = variabls[i].trim();
    var typs = variabls[i].split(' ');

    var dataType = typs[0].replaceAll("?", "");
//     print(dataType);
    var dataTypeForReturn = dataType;
    if(dataType == "String"){
      dataType = "\"\"";
    }else if(dataType == "bool"){
      dataType = "false";
    }else if(dataType == "int"){
      dataType = "0";
    }else if(dataType.contains("List<")){
      dataType = "[]";
    }else{
      dataType+="()";
    }

    String s =
        "$dataTypeForReturn get ${typs[1].replaceAll("_", "")} { ${typs[1]} ??= $dataType; return ${typs[1]}!;} ";
    print(s);
  }
}
