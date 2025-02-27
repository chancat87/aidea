import 'package:askaide/helper/constant.dart';
import 'package:askaide/repo/api_server.dart';
import 'package:askaide/repo/model/model.dart' as mm;
import 'package:askaide/repo/settings_repo.dart';

/// 模型聚合，用于聚合多种厂商的模型
class ModelAggregate {
  static late SettingRepository settings;

  static void init(SettingRepository settings) {
    ModelAggregate.settings = settings;
  }

  /// 支持的模型列表
  static Future<List<mm.Model>> models({bool cache = true}) async {
    return (await APIServer().models(cache: cache))
        .map(
          (e) => mm.Model(
            e.id.split(':').last,
            e.name,
            e.category,
            shortName: e.shortName,
            description: e.description,
            priceInfo: e.priceInfo,
            isChatModel: e.isChat,
            disabled: e.disabled,
            category: e.category,
            tag: e.tag,
            avatarUrl: e.avatarUrl,
            supportVision: e.supportVision,
            supportReasoning: e.supportReasoning,
            supportSearch: e.supportSearch,
            tagTextColor: e.tagTextColor,
            tagBgColor: e.tagBgColor,
            isNew: e.isNew,
            isDefault: e.isDefault,
            userNoPermission: e.userNoPermission,
          ),
        )
        .toList();
  }

  /// 根据模型唯一id查找模型
  static Future<mm.Model> model(String uid) async {
    uid = uid.split(':').last;

    final supportModels = await models();
    return supportModels.firstWhere(
      (element) => element.uid() == uid || element.id == uid,
      orElse: () => mm.Model(defaultChatModel, defaultChatModel, 'openai', category: modelTypeOpenAI),
    );
  }
}
