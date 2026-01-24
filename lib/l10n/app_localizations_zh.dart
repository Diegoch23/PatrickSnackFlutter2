// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Patrik\'s Snack';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get continueButton => '继续';

  @override
  String get cancel => '取消';

  @override
  String get loginTitle => '登录';

  @override
  String get email => '电子邮件';

  @override
  String get password => '密码';

  @override
  String get login => '登录';

  @override
  String get internetRequired => '首次登录需要互联网连接。';

  @override
  String get invalidCredentials => '凭据无效';

  @override
  String get connectionError => '与Hostinger的连接错误';

  @override
  String get homeTitle => 'Patrik\'s Snack';

  @override
  String get homeGreeting => '你好👋';

  @override
  String get homeQuestion => '今天你想做什么？';

  @override
  String get logout => '登出';

  @override
  String get syncPending => '同步待处理';

  @override
  String get offlineMode => '离线模式已激活';

  @override
  String pendingRecords(Object count) {
    return '您有 $count 条本地保存的记录。';
  }

  @override
  String get generateCodes => '生成代码';

  @override
  String get generateCodesSubtitle => '为产品创建条形码标签';

  @override
  String get scanProduct => '扫描产品';

  @override
  String get scanProductSubtitle => '记录入库或销售';

  @override
  String get inventory => '库存';

  @override
  String get inventorySubtitle => '查看当前库存';

  @override
  String get logoutDialogTitle => '登出';

  @override
  String get logoutDialogMessage => '您确定要退出系统吗？';

  @override
  String get exit => '退出';

  @override
  String get generatorTitle => '代码生成器';

  @override
  String get loading => '加载中...';

  @override
  String get noRecords => '未找到同步记录。';

  @override
  String get codeGenerated => '代码已生成';

  @override
  String get saveToGallery => '保存到相册';

  @override
  String get imageSaved => '图片保存成功';

  @override
  String get saveError => '保存图片时出错';

  @override
  String get scannerMode => '扫描模式';

  @override
  String get flashlight => '手电筒';

  @override
  String get rotate => '旋转';

  @override
  String get productDetected => '检测到产品';

  @override
  String get description => '描述：';

  @override
  String get identifier => '标识符（SKU）：';

  @override
  String get defineQuantity => '定义要处理的数量：';

  @override
  String get sale => '销售';

  @override
  String get entry => '入库';

  @override
  String get validationError => '⚠️ 验证错误：请输入大于0的数量';

  @override
  String get transactionCompleted => '交易完成';

  @override
  String get inventoryTitle => 'Patrik\'s Snack 库存';

  @override
  String get searchPlaceholder => '按名称或SKU搜索...';

  @override
  String get noProducts => '未找到产品';

  @override
  String get offlineData => '显示本地数据（离线）';

  @override
  String get noConnectionNoCache => '无连接且无缓存数据';

  @override
  String get stock => '库存';

  @override
  String get category => '分类：';

  @override
  String get unknownProduct => '未知产品';
}
