import 'package:flutter/material.dart';

class SmartCityInfoView extends StatelessWidget {
  const SmartCityInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;
        
        return Container(
          color: Colors.white,
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: constraints.maxWidth < 600 ? 16 : 64,
            vertical: constraints.maxWidth < 600 ? 48 : 100,
          ),
          child: Column(
            children: [
              // Ana Başlık
              FadeInWidget(
                delay: const Duration(milliseconds: 100),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'asset/icons/remove.png',
                          width: 32,
                          height: 32,
                          color: const Color(0xFF0A4A9D),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Akıllı Şehir Nedir?',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: isMobile ? 28 : 42,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1F2937),
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Text(
                        'Akıllı şehirler; teknoloji, yenilikçilik ve sürdürülebilirliği birleştirerek vatandaşların yaşam kalitesini yükseltmeyi hedefleyen kentsel dönüşüm projeleridir. Erzurum Akıllı Şehir projesi, dijital altyapıyı şehrin tarihi dokusuyla harmanlayarak daha verimli, güvenli ve yaşanabilir bir kent sunmayı amaçlıyor.',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: isMobile ? 16 : 18,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6B7280),
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 80),
              
              // 4 Temel Direk
              FadeInWidget(
                delay: const Duration(milliseconds: 200),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'asset/icons/remove.png',
                          width: 32,
                          height: 32,
                          color: const Color(0xFF0A4A9D),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Akıllı Şehrin 4 Temel Direği',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: isMobile ? 24 : 36,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1F2937),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                    
                    // Direkler Grid
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final crossAxisCount = constraints.maxWidth > 1200 ? 4 : 
                                            constraints.maxWidth > 800 ? 2 : 1;
                        
                        return GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                          childAspectRatio: 1.2,
                          children: [
                            _buildPillarCard(
                              title: 'Teknoloji Entegrasyonu',
                              description: 'Nesnelerin İnterneti (IoT), yapay zekâ ve büyük veri analitiği ile trafik, enerji ve atık yönetimi gibi sistemler optimize edilir.',
                              icon: 'asset/icons/cpu.png',
                            ),
                            _buildPillarCard(
                              title: 'Sürdürülebilirlik',
                              description: 'Yenilenebilir enerji kaynakları, akıllı aydınlatma ve karbon ayak izini azaltan projelerle çevreci bir gelecek inşa edilir.',
                              icon: 'asset/icons/sustainable.png',
                            ),
                            _buildPillarCard(
                              title: 'Katılımcı Yönetim',
                              description: 'Vatandaşlar, mobil uygulamalar ve dijital platformlar aracılığıyla karar süreçlerine doğrudan katkı sağlar.',
                              icon: 'asset/icons/group.png',
                            ),
                            _buildPillarCard(
                              title: 'Yaşam Kalitesi',
                              description: 'Akıllı sağlık hizmetleri, güvenlik sistemleri ve dijital kültür hizmetleriyle insan odaklı çözümler sunulur.',
                              icon: 'asset/icons/quality-of-life.png',
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 80),
              
              // Erzurum Uygulamaları
              FadeInWidget(
                delay: const Duration(milliseconds: 300),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'asset/icons/remove.png',
                          width: 32,
                          height: 32,
                          color: const Color(0xFF0A4A9D),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Erzurum\'da Akıllı Şehir Uygulamaları',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: isMobile ? 24 : 36,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1F2937),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                    
                    // Uygulamalar Listesi
                    Container(
                      constraints: const BoxConstraints(maxWidth: 1000),
                      child: Column(
                        children: [
                          _buildApplicationItem(
                            title: 'Akıllı Ulaşım',
                            description: 'Trafik sensörleri ve gerçek zamanlı yönlendirmelerle seyahat süresi %30 azaltıldı.',
                            icon: 'asset/icons/bus.png',
                          ),
                          const SizedBox(height: 24),
                          _buildApplicationItem(
                            title: 'Enerji Verimliliği',
                            description: 'Sokak aydınlatmalarında hareket sensörlü LED sistemlerle enerji tasarrufu sağlanıyor.',
                            icon: 'asset/icons/target.png',
                          ),
                          const SizedBox(height: 24),
                          _buildApplicationItem(
                            title: 'Dijital Yönetişim',
                            description: '"Erzurum Cep" uygulaması ile belediye hizmetleri tek tıkla vatandaşa ulaşıyor.',
                            icon: 'asset/icons/transformation.png',
                          ),
                          const SizedBox(height: 24),
                          _buildApplicationItem(
                            title: 'Akıllı Tarım',
                            description: 'İklim verileri analiz edilerek çiftçilere optimize üretim tavsiyeleri sunuluyor.',
                            icon: 'asset/icons/agriculture.png',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 80),
              
              // Alt Slogan
              FadeInWidget(
                delay: const Duration(milliseconds: 400),
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF0A4A9D).withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '"Erzurum; karın beyazlığında, teknolojinin berraklığıyla aydınlanan bir akıllı şehir modelidir."',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: isMobile ? 18 : 22,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0A4A9D),
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPillarCard({
    required String title,
    required String description,
    required String icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                  Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF0A4A9D).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.asset(
            icon,
            width: 24,
            height: 24,
            color: const Color(0xFF0A4A9D),
          ),
        ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationItem({
    required String title,
    required String description,
    required String icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0A4A9D).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              icon,
              width: 24,
              height: 24,
              color: const Color(0xFF0A4A9D),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF6B7280),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// FadeInWidget sınıfı (eğer mevcut değilse)
class FadeInWidget extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const FadeInWidget({
    super.key,
    required this.child,
    this.delay = Duration.zero,
  });

  @override
  State<FadeInWidget> createState() => _FadeInWidgetState();
}

class _FadeInWidgetState extends State<FadeInWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: widget.child,
    );
  }
}
