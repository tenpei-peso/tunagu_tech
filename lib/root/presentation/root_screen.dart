import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class RootScreen extends StatelessWidget {
  // StatefulNavigationShellを受け取るように変更
  const RootScreen({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) => Scaffold(
      // bodyにはnavigationShellを渡す
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '検索',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'メッセージ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'プロフィール',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '設定',
          ),
        ],
        // タブインデックスはnavigationShellから取得できる
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => _onItemTapped(index, context),
      ),
    );

  // タップされた時の処理
  void _onItemTapped(int index, BuildContext context) {
    // タブ間の遷移はこのように行う
    navigationShell.goBranch(
      index,
      // 第二引数にtrueを渡すと、タブのトップルートに遷移する
      // つまり以下のようにすると、非アクティブなタブ（現在のタブとは別のタブ）をクリック
      // した場合には状態を保ったままそのタブに遷移し、アクティブなタブ（現在のタブ）を
      // クリックした場合にはトップのルートに戻るという挙動になる
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}