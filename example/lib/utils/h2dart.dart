/// 内容结构
class ContentStructure {
  /// 方法结构
  List<FuncStructure> funcStructures;

  ContentStructure({this.funcStructures});
}

/// 方法结构
class FuncStructure {
  FuncStructure({
    this.abstract,
    this.discussion,
    this.params,
    this.result,
    this.func,
  });

  // 摘要
  List<String> abstract;
  // 描述
  List<String> discussion;
  // 参数
  List<Value> params;
  // 返回结果
  Value result;
  // 方法
  String func;
}

/// 参数或返回值
class Value {
  /// 名字
  String name;
  /// 类型
  String type;
  /// 摘要
  String abstract;
}

// 头文件转dart
String h2Dart (String content, {
  String importContent = '''
import 'dart:ffi';

import 'jsc_ffi.dart';
''',
  String dynamicLibraryName = 'jscLib',
}) {
  return toDart(readH(content),
    importContent: importContent,
    dynamicLibraryName: dynamicLibraryName,
  );
}

// 解析头文件
ContentStructure readH(String content) {
  List<FuncStructure> funcStructures = [];
  // 分行
  List<String> lines = content.split('\n');
  // 缓存参数
  FuncStructure funStructure;
  List<Value> params;
  Map<String, String> paramsAbstract;
  Map<String, String> resultAbstract;
  // 解析
  for (int i = 0; i < lines.length; i++) {
    String line = lines[i].trim();
    // 方法开始
    if (line.startsWith('@function')) {
      funStructure = FuncStructure();
      params = [];
      paramsAbstract = {};
      resultAbstract = {};
    }
    // 摘要
    else if (line.startsWith('@abstract')) {
      List<String> abstract = [];
      try {
        abstract.add(line.split('@abstract')[1].trim());
      }catch (e) {
        print('@abstract $e');
      }
      while (true) {
        if (i + 1 >= lines.length) break;
        String nextLine = lines[i + 1].trim();
        // 判断是否换行
        if (nextLine.startsWith('@') || nextLine.startsWith('*/')) break;
        abstract.add(nextLine.trim());
        i++;
      }
      funStructure?.abstract = abstract;
    }
    // 描述
    else if (line.startsWith('@discussion')) {
      List<String> discussion = [];
      try {
        discussion.add(line.split('@discussion')[1].trim());
      }catch (e) {
        print('@discussion $e');
      }
      while (true) {
        if (i + 1 >= lines.length) break;
        String nextLine = lines[i + 1].trim();
        // 判断是否换行
        if (nextLine.startsWith('@') || nextLine.startsWith('*/')) break;
        discussion.add(nextLine.trim());
        i++;
      }
      funStructure?.discussion = discussion;
    }
    // 参数摘要
    else if (line.startsWith('@param')) {
      List<String> abstract = [];
      String name = line.split(' ')[1];
      try {
        abstract.add(line.split('@param $name')[1].trim());
      }catch (e) {
        print('@param $e');
      }
      while (true) {
        if (i + 1 >= lines.length) break;
        String nextLine = lines[i + 1].trim();
        // 判断是否换行
        if (nextLine.startsWith('@') || nextLine.startsWith('*/')) break;
        abstract.add(nextLine.trim());
        i++;
      }
      if (paramsAbstract != null) {
        paramsAbstract[name] = abstract.join(' ');
      }
    }
    // 返回值
    else if (line.startsWith('@result')) {
      List<String> abstract = [];
      try {
        abstract.add(line.split('@result')[1].trim());
      }catch (e) {
        print('@result $e');
      }
      while (true) {
        if (i + 1 >= lines.length) break;
        String nextLine = lines[i + 1].trim();
        // 判断是否换行
        if (nextLine.startsWith('@') || nextLine.startsWith('*/')) break;
        abstract.add(nextLine.trim());
        i++;
      }
      if (resultAbstract != null) {
        resultAbstract['@result'] = abstract.join(' ');
      }
    }
    // JSC导出
    else if (line.startsWith('JS_EXPORT')) {
      // 方法并结束
      if (funStructure != null) {
        // 返回类型
        Value value = Value();
        value.name = '@result';
        value.type = line.split(' ')[1];
        value.abstract = resultAbstract['@result'];
        funStructure.result = value;
        // 方法名称
        if (line.split(' ')[2] == 'const') {
          funStructure.func = line.split(' ')[3].split('(')[0];
        } else {
          funStructure.func = line.split(' ')[2].split('(')[0].replaceAll('*', '');
        }
        // 方法参数
        String paramsStr = '';
        try {
          paramsStr = line.substring(line.indexOf('(') + 1, line.indexOf(')')).trim();
        } catch (e) {
          print('@JS_EXPORT $e');
        }
        if (paramsStr != '' && paramsStr != 'void') {
          paramsStr.split(',').forEach((paramStr) {
            List<String> paramSplits = paramStr.trim().split(' ');
            if (paramSplits.length == 3) {
              paramSplits.removeAt(0);
            }
            Value value = Value();
            value.type = paramSplits[0].trim();
            value.name = paramSplits[1].trim();
            // 判断是否为指针
            if (value.name.startsWith('*')) {
              int start = 0;
              String pointer = '';
              while(true) {
                int nextStart = value.name.indexOf('*', start);
                if (nextStart < 0) break;
                start = nextStart + 1;
                pointer += '*';
              }
              value.name = value.name.replaceAll(pointer, '');
              value.type += pointer;
            }
            // 判断数组
            if (value.name.endsWith('[]')) {
              value.name = value.name.replaceAll('[]', '');
              value.type += '[]';
            }
            value.abstract = paramsAbstract[value.name];
            params.add(value);
          });
        }
        funStructure?.params = params;
        if (funStructure != null) {
          funcStructures.add(funStructure);
          funStructure = null;
          params = null;
          paramsAbstract = null;
          resultAbstract = null;
        }
      }
    }
  }
  return ContentStructure(funcStructures: funcStructures);
}

// 转换为dart
String toDart(ContentStructure contentStructure, {
  String importContent = '''
import 'dart:ffi';

import 'jsc_ffi.dart';
''',
  String dynamicLibraryName = 'jscLib',
}) {
  String dartContent = importContent;
  // 方法
  if (contentStructure.funcStructures != null && contentStructure.funcStructures.isNotEmpty) {
    contentStructure.funcStructures.forEach((funcStructure) {
      // 摘要
      if (funcStructure.abstract != null && funcStructure.abstract.isNotEmpty) {
        funcStructure.abstract.forEach((item) {
          dartContent += '\n /// ${item ?? ''}';
        });
      }
      // 描述
      if (funcStructure.discussion != null && funcStructure.discussion.isNotEmpty) {
        funcStructure.discussion.forEach((item) {
          dartContent += '\n /// ${item ?? ''}';
        });
      }
      // 参数
      if (funcStructure.params != null && funcStructure.params.isNotEmpty) {
        funcStructure.params.forEach((param) {
          dartContent += '\n /// ${param.name != null ? '[${param.name}]' : ''} ${param.type != null ? '(${param.type})' : ''} ${param.abstract ?? ''}';
        });
      }
      // 返回值
      if (funcStructure.result != null && funcStructure.result.type != 'void') {
        dartContent += '\n /// ${funcStructure.result.name != null ? '[${funcStructure.result.name}]' : ''} ${funcStructure.result.type != null ? '(${funcStructure.result.type})' : ''} ${funcStructure.result.abstract ?? ''}';
      }
      // 方法
      String dartFunc = '\nfinal';
      // dart返回值
      if (funcStructure.result != null) {
        dartFunc += ' ${typeC2Dart(funcStructure.result.type)}';
      } else {
        dartFunc += ' ${typeC2Dart('void')}';
      }
      // dart方法
      dartFunc += ' Function(';
      if (funcStructure.params != null && funcStructure.params.isNotEmpty) {
        for (int i = 0; i < funcStructure.params.length; i++) {
          Value param = funcStructure.params[i];
          if (i != 0) {
            dartFunc += ', ';
          }
          dartFunc += '${typeC2Dart(param.type)} ${param.name}';
        }
      }
      dartFunc += ') ';
      // dart方法名
      String firstName = funcStructure.func.substring(0, 1);
      dartFunc += funcStructure.func.replaceFirst(firstName, firstName.toLowerCase());
      dartFunc += ' = jscLib.lookup<NativeFunction<';
      // ffi返回值
      if (funcStructure.result != null) {
        dartFunc += '${typeC2DartFfi(funcStructure.result.type)}';
      } else {
        dartFunc += ' ${typeC2Dart('void')}';
      }
      // ffi方法
      dartFunc += ' Function(';
      if (funcStructure.params != null && funcStructure.params.isNotEmpty) {
        for (int i = 0; i < funcStructure.params.length; i++) {
          Value param = funcStructure.params[i];
          if (i != 0) {
            dartFunc += ', ';
          }
          dartFunc += '${typeC2DartFfi(param.type)}';
        }
      }
      dartFunc += ')>>';
      // C方法名
      dartFunc += '(\'${funcStructure.func}\').asFunction();';
      dartContent += '$dartFunc\n';
    });
  }
  return dartContent;
}

/// C类型转dart类型
String typeC2Dart(String type) {
  if (type == 'void') {
    return 'void';
  } else if (type == 'bool') {
    return 'int';
  } else if (type == 'int' || type == 'long' || type == 'size_t') {
    return 'int';
  } else if (type == 'float' || type == 'double') {
    return 'double';
  }
  return 'Pointer';
}

/// C类型转dart ffi类型
String typeC2DartFfi(String type) {
  if (type == 'void') {
    return 'Void';
  } else if (type == 'bool') {
    return 'Int8';
  } else if (type == 'int') {
    return 'Int32';
  } else if (type == 'long') {
    return 'Int64';
  } else if (type == 'size_t') {
    return 'Uint64';
  } else if (type == 'float' || type == 'double') {
    return 'Double';
  }
  return 'Pointer';
}