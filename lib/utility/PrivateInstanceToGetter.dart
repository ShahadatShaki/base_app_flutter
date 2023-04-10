void main() {

  var v = "  bool? _status;String? _message;  T? _data;";
  var variabls = v.split(';');
//   print(variabls.length);
//   print(variabls);
  for (int i = 0; i < variabls.length - 1; i++) {
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
