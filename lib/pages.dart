import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'components.dart';
import 'custom_cursor.dart';
import 'package:flutter/scheduler.dart';

class TechnologyView extends StatelessWidget {
  final VoidCallback onBack;
  const TechnologyView({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final techStack = [
      {
        'categoryAr': 'تكامل الذكاء الاصطناعي (AI)',
        'categoryEn': 'AI Integration',
        'items': ['RAG Pipelines', 'LLM Fine-tuning', 'Vector Databases (Pinecone, PGVector)', 'TensorFlow & PyTorch Inference']
      },
      {
        'categoryAr': 'تقنيات الويب ثلاثي الأبعاد والويب المتقدم',
        'categoryEn': 'WebGL & 3D Interactive',
        'items': ['Three.js & React Three Fiber', 'Flutter Custom Painters', 'WebGL Custom Shaders', 'Blender Asset Optimization']
      },
      {
        'categoryAr': 'منصات السحاب وتوسيع النظم (DevOps)',
        'categoryEn': 'Cloud & Architecture',
        'items': ['Kubernetes & Docker', 'AWS, GCP, Azure Architectures', 'Terraform (IaC)', 'CI/CD Pipelines (GitHub Actions)']
      },
      {
        'categoryAr': 'تطبيقات الهواتف والويب والمنصات المتعددة',
        'categoryEn': 'Cross-Platform App Engine',
        'items': ['Flutter (Web, iOS, Android)', 'Next.js & React Frameworks', 'TailwindCSS & Framer Motion', 'State Management (Riverpod, Bloc)']
      },
    ];

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1152),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button
            CustomCursorHover(
              child: TextButton.icon(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back, color: Color(0xFF3FD2FF)),
                label: Text(
                  tr('العودة للرئيسية', 'Back to Home'),
                  style: const TextStyle(color: Color(0xFF3FD2FF), fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              tr('// ترسانتنا التقنية', '// OUR TECH STACK'),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                color: Color(0xFF3FD2FF),
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              tr('التقنيات التي نقوم بتوظيفها لبناء المستقبل', 'Technologies We Wield to Shape the Future'),
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 48),
            
            // Grid of categories
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: techStack.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width < 768 ? 1 : 2,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 1.5,
              ),
              itemBuilder: (context, index) {
                final category = techStack[index];
                return Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFF141A29).withOpacity(0.5),
                    border: Border.all(color: const Color(0xFF3FD2FF).withOpacity(0.15)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr(category['categoryAr'] as String, category['categoryEn'] as String),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3FD2FF),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: (category['items'] as List<String>).map((item) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.bolt, color: Color(0xFF3FD2FF), size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    item,
                                    style: const TextStyle(color: Color(0xFFA6ABB6), fontSize: 14),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class StudioView extends StatelessWidget {
  final VoidCallback onBack;
  const StudioView({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final portfolio = [
      {
        'titleAr': 'تطبيق الذكاء الاصطناعي الذكي',
        'titleEn': 'SmartAI Chatbot Platform',
        'descAr': 'نظام دعم ذكي فائق السرعة يعتمد على معالجة اللغة الطبيعية والوكلاء المبرمجين لمؤسسات الاتصالات.',
        'descEn': 'High-performance conversational AI with RAG pipelines tailored for major telecom enterprises.',
        'tag': 'AI & Web'
      },
      {
        'titleAr': 'منصة 3D Configurator التفاعلية',
        'titleEn': 'Interactive 3D Configurator',
        'descAr': 'عرض تفاعلي ثلاثي الأبعاد للمنتجات والسيارات في الوقت الحقيقي يعمل بكفاءة متناهية على المتصفحات.',
        'descEn': 'Cinematic 3D customizer for retail and automotive clients running smoothly in web browsers.',
        'tag': '3D WebGL'
      },
      {
        'titleAr': 'نظام فوترة وإدارة SaaS السحابية',
        'titleEn': 'Enterprise SaaS Core',
        'descAr': 'بنية برمجية متكاملة لخدمة أكثر من مليون مستخدم متزامن تشمل الفوترة الفورية والتحليلات البيانية.',
        'descEn': 'Cloud-native architecture managing millions of concurrent connections with real-time billing.',
        'tag': 'Cloud Scale'
      },
    ];

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1152),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button
            CustomCursorHover(
              child: TextButton.icon(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back, color: Color(0xFF3FD2FF)),
                label: Text(
                  tr('العودة للرئيسية', 'Back to Home'),
                  style: const TextStyle(color: Color(0xFF3FD2FF), fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              tr('// مشاريع الاستوديو الخاصة بنا', '// STUDIO PORTFOLIO'),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                color: Color(0xFF3FD2FF),
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              tr('نحول الأفكار المعقدة إلى منتجات برمجية ناجحة', 'Turning Complex Visions Into Elegant Software'),
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 48),
            
            // Grid of works
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: portfolio.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width < 768 ? 1 : 3,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                final project = portfolio[index];
                return Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFF141A29).withOpacity(0.5),
                    border: Border.all(color: const Color(0xFF3FD2FF).withOpacity(0.15)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3FD2FF).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF3FD2FF).withOpacity(0.3)),
                        ),
                        child: Text(
                          project['tag']!,
                          style: const TextStyle(color: Color(0xFF3FD2FF), fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        tr(project['titleAr']!, project['titleEn']!),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        tr(project['descAr']!, project['descEn']!),
                        style: const TextStyle(color: Color(0xFFA6ABB6), fontSize: 14, height: 1.5),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ContactView extends StatefulWidget {
  final VoidCallback onBack;
  const ContactView({super.key, required this.onBack});

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final baseUrl = kIsWeb ? "" : "http://localhost:5555";
      final response = await http.post(
        Uri.parse("$baseUrl/api/contact"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": _nameController.text.trim(),
          "email": _emailController.text.trim(),
          "message": _messageController.text.trim(),
        }),
      );

      final resData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          _successMessage = tr("تم إرسال رسالتك بنجاح! شكراً لك.", "Message sent successfully! Thank you.");
          _nameController.clear();
          _emailController.clear();
          _messageController.clear();
        });
      } else {
        setState(() {
          _errorMessage = resData['message'] ?? tr("حدث خطأ ما.", "An error occurred.");
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = tr("تعذر الاتصال بخادم الرسائل.", "Could not connect to contact server.");
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button
            CustomCursorHover(
              child: TextButton.icon(
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back, color: Color(0xFF3FD2FF)),
                label: Text(
                  tr('العودة للرئيسية', 'Back to Home'),
                  style: const TextStyle(color: Color(0xFF3FD2FF), fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              tr('// اتصل بنا', '// CONTACT US'),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                color: Color(0xFF3FD2FF),
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              tr('دعنا نبني شيئاً مذهلاً معاً', 'Let\'s Build Something Amazing Together'),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: const Color(0xFF141A29).withOpacity(0.5),
                border: Border.all(color: const Color(0xFF3FD2FF).withOpacity(0.15)),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_errorMessage != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                        ),
                        child: Text(_errorMessage!, style: const TextStyle(color: Colors.redAccent)),
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (_successMessage != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.withOpacity(0.3)),
                        ),
                        child: Text(_successMessage!, style: const TextStyle(color: Colors.green)),
                      ),
                      const SizedBox(height: 16),
                    ],

                    Text(tr("الاسم الكامل", "Full Name"), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration("John Doe"),
                      validator: (val) => val == null || val.isEmpty ? tr("الرجاء إدخال الاسم", "Please enter your name") : null,
                    ),
                    const SizedBox(height: 20),

                    Text(tr("البريد الإلكتروني", "Email Address"), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration("john@example.com"),
                      validator: (val) => val == null || !val.contains('@') ? tr("الرجاء إدخال بريد صالح", "Please enter a valid email") : null,
                    ),
                    const SizedBox(height: 20),

                    Text(tr("الرسالة", "Message"), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _messageController,
                      maxLines: 4,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration(tr("اكتب تفاصيل استفسارك هنا...", "Describe your request here...")),
                      validator: (val) => val == null || val.isEmpty ? tr("الرجاء كتابة رسالة", "Please write a message") : null,
                    ),
                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: TextButton(
                        onPressed: _isLoading ? null : _sendMessage,
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF3FD2FF),
                          foregroundColor: const Color(0xFF090D16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _isLoading 
                            ? const CircularProgressIndicator(color: Color(0xFF090D16))
                            : Text(tr("إرسال الرسالة", "Send Message"), style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFF090D16),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white24),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: const Color(0xFF3FD2FF).withOpacity(0.15)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF3FD2FF)),
      ),
    );
  }
}

class LaunchProjectView extends StatefulWidget {
  final VoidCallback onBack;
  const LaunchProjectView({super.key, required this.onBack});

  @override
  State<LaunchProjectView> createState() => _LaunchProjectViewState();
}

class _LaunchProjectViewState extends State<LaunchProjectView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _budgetController = TextEditingController();
  final _contactController = TextEditingController();
  
  String _selectedPlatform = "Web App";
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _budgetController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _submitProject() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final baseUrl = kIsWeb ? "" : "http://localhost:5555";
      final response = await http.post(
        Uri.parse("$baseUrl/api/launch"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "title": _titleController.text.trim(),
          "description": _descController.text.trim(),
          "budget": _budgetController.text.trim(),
          "platform": _selectedPlatform,
          "contact": _contactController.text.trim(),
        }),
      );

      final resData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          _successMessage = tr("تم إرسال اقتراح مشروعك بنجاح! سنتصل بك قريباً.", "Project proposal submitted successfully! We will contact you soon.");
          _titleController.clear();
          _descController.clear();
          _budgetController.clear();
          _contactController.clear();
        });
      } else {
        setState(() {
          _errorMessage = resData['message'] ?? tr("حدث خطأ ما.", "An error occurred.");
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = tr("تعذر الاتصال بخادم إرسال المشاريع.", "Could not connect to project server.");
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button
            CustomCursorHover(
              child: TextButton.icon(
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back, color: Color(0xFF3FD2FF)),
                label: Text(
                  tr('العودة للرئيسية', 'Back to Home'),
                  style: const TextStyle(color: Color(0xFF3FD2FF), fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              tr('// أطلق فكرتك للمستقبل', '// LAUNCH YOUR PROJECT'),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                color: Color(0xFF3FD2FF),
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              tr('صمم إطار عمل مشروعك القادم', 'Blueprint Your Next Big Thing'),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: const Color(0xFF141A29).withOpacity(0.5),
                border: Border.all(color: const Color(0xFF3FD2FF).withOpacity(0.15)),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_errorMessage != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                        ),
                        child: Text(_errorMessage!, style: const TextStyle(color: Colors.redAccent)),
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (_successMessage != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.withOpacity(0.3)),
                        ),
                        child: Text(_successMessage!, style: const TextStyle(color: Colors.green)),
                      ),
                      const SizedBox(height: 16),
                    ],

                    Text(tr("عنوان المشروع", "Project Title"), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration(tr("مثال: منصة تسوق متقدمة", "E.g. Next-gen E-commerce")),
                      validator: (val) => val == null || val.isEmpty ? tr("الرجاء كتابة العنوان", "Please enter title") : null,
                    ),
                    const SizedBox(height: 20),

                    Text(tr("وصف المشروع", "Project Description"), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descController,
                      maxLines: 3,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration(tr("ما هي فكرتك وماذا تريد بناءه؟", "What is your idea and what do you want to build?")),
                      validator: (val) => val == null || val.isEmpty ? tr("الرجاء كتابة الوصف", "Please enter description") : null,
                    ),
                    const SizedBox(height: 20),

                    Text(tr("نوع المنصة", "Platform Type"), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedPlatform,
                      dropdownColor: const Color(0xFF141A29),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: _inputDecoration(""),
                      items: ["Web App", "Mobile App", "AI & Data Pipeline", "3D & Interactive Web"].map((String val) {
                        return DropdownMenuItem<String>(
                          value: val,
                          child: Text(val),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        if (newVal != null) {
                          setState(() {
                            _selectedPlatform = newVal;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 20),

                    Text(tr("الميزانية التقديرية", "Estimated Budget"), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _budgetController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration("\$10,000 - \$25,000"),
                    ),
                    const SizedBox(height: 20),

                    Text(tr("معلومات الاتصال بك", "Your Contact Info"), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _contactController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration(tr("البريد الإلكتروني أو رقم الهاتف", "Email or Phone Number")),
                      validator: (val) => val == null || val.isEmpty ? tr("الرجاء كتابة وسيلة الاتصال", "Please write contact info") : null,
                    ),
                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: TextButton(
                        onPressed: _isLoading ? null : _submitProject,
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF3FD2FF),
                          foregroundColor: const Color(0xFF090D16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _isLoading 
                            ? const CircularProgressIndicator(color: Color(0xFF090D16))
                            : Text(tr("إرسال طلب المشروع", "Submit Project"), style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFF090D16),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white24),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: const Color(0xFF3FD2FF).withOpacity(0.15)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF3FD2FF)),
      ),
    );
  }
}

// -------------------------------------------------------------
// Interactive Capability Detail View
// -------------------------------------------------------------

class CapabilityDetailView extends StatefulWidget {
  final String capabilityId;
  final VoidCallback onBack;

  const CapabilityDetailView({
    super.key,
    required this.capabilityId,
    required this.onBack,
  });

  @override
  State<CapabilityDetailView> createState() => _CapabilityDetailViewState();
}

class _CapabilityDetailViewState extends State<CapabilityDetailView> with SingleTickerProviderStateMixin {
  late AnimationController _demoController;
  
  // AI State
  final List<String> _aiConsoleLogs = [];
  bool _aiRunning = false;
  double _aiProgress = 0.0;
  String _aiSelectedPrompt = "Analyze Cloud Usage Patterns";

  // 3D State
  double _particleSpeed = 1.0;
  double _particleCount = 60.0;
  Color _particleColor = const Color(0xFF3FD2FF);

  // SaaS State
  int _saasUsers = 12450;
  double _saasMrr = 45900.00;
  int _saasApiRate = 180;
  bool _saasPeakActive = false;

  // Cyber Security State
  bool _scanningActive = false;
  double _radarAngle = 0.0;
  final List<Map<String, dynamic>> _securityEvents = [];

  // Architecture State
  int _replicaCount = 3;
  double _trafficLoad = 30.0; // percentage
  bool _stressTestRunning = false;

  // Immersive State
  final List<PhysicsBall> _balls = [];
  Offset? _gravityNode;

  @override
  void initState() {
    super.initState();
    _demoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
        setState(() {});
      })..repeat();

    // Pre-populate security events
    _securityEvents.addAll([
      {"time": "01:12:04", "type": "SUCCESS", "msgAr": "تشفير قاعدة البيانات نشط", "msgEn": "Database transparent encryption active"},
      {"time": "01:14:22", "type": "INFO", "msgAr": "بوابة API آمنة 100%", "msgEn": "API Gateway secured, HTTPS enforced"},
    ]);
    
    // Spawn initial physics balls
    _balls.addAll([
      PhysicsBall(x: 100, y: 150, vx: 3, vy: 2, radius: 15, color: const Color(0xFF3FD2FF)),
      PhysicsBall(x: 250, y: 80, vx: -2, vy: 4, radius: 20, color: const Color(0xFFAD00FF)),
    ]);
  }

  @override
  void dispose() {
    _demoController.dispose();
    super.dispose();
  }



  // AI Pipeline Runner Simulation
  void _runAiPipeline() async {
    if (_aiRunning) return;
    setState(() {
      _aiRunning = true;
      _aiProgress = 0.0;
      _aiConsoleLogs.clear();
      _aiConsoleLogs.add(tr("[INFO] بدء تشغيل خط إمداد الوكيل الذكي...", "[INFO] Initializing Intelligent Agent pipeline..."));
    });

    final steps = [
      tr("[RAG] البحث الدلالي في Pinecone Vector Database...", "[RAG] Semantic search inside Pinecone Vector Database..."),
      tr("[INFO] تم استرداد 4 فقرات ذات صلة بالطلب.", "[INFO] Retrieved 4 relevant context passages."),
      tr("[AGENT] تجميع وتغذية سياق البيانات للنموذج اللغوي (LLM)...", "[AGENT] Feeding context and compiling system prompt for LLM..."),
      tr("[LLM] تم توليد الإجابة والاستنتاج خلال 340ms بنجاح.", "[LLM] Reasoning finished in 340ms successfully."),
      tr("[DB] حفظ نسخة من سجل العمليات محلياً...", "[DB] Syncing transaction log to local audit database..."),
      tr("[SUCCESS] اكتمال عملية الاستدعاء. النتيجة جاهزة للمستخدم.", "[SUCCESS] Execution completed. Context synthesized successfully.")
    ];

    for (int i = 0; i < steps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      setState(() {
        _aiConsoleLogs.add(steps[i]);
        _aiProgress = (i + 1) / steps.length;
      });
    }

    setState(() {
      _aiRunning = false;
    });
  }

  // Security Scan Simulation
  void _runSecurityScan() async {
    if (_scanningActive) return;
    setState(() {
      _scanningActive = true;
    });

    // Animate radar angle
    for (int i = 0; i < 40; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
      if (!mounted) return;
      setState(() {
        _radarAngle += 0.2;
      });
    }

    setState(() {
      _scanningActive = false;
      _securityEvents.insert(0, {
        "time": "الآن",
        "type": "SUCCESS",
        "msgAr": "تم فحص المنافذ. لم يتم العثور على تهديدات.",
        "msgEn": "Ports audited. 0 threats detected."
      });
      _securityEvents.insert(0, {
        "time": "الآن",
        "type": "MITIGATED",
        "msgAr": "تم منع محاولة اختراق SQL Injection بنجاح.",
        "msgEn": "SQL injection attempt blocked and IP flagged."
      });
    });
  }

  // Architecture Load Balancing / Stress testing
  void _toggleStressTest() async {
    setState(() {
      _stressTestRunning = !_stressTestRunning;
      _trafficLoad = _stressTestRunning ? 95.0 : 30.0;
    });

    if (_stressTestRunning) {
      // Periodic check if replica count is too low for the load
      while (_stressTestRunning && mounted) {
        await Future.delayed(const Duration(seconds: 2));
        if (_replicaCount < 5 && _stressTestRunning) {
          // Trigger automatic scaling warning or advice
          setState(() {
            _saasApiRate = 5000 + (1000 * _replicaCount);
          });
        }
      }
    } else {
      setState(() {
        _saasApiRate = 180;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine info based on capabilityId
    String title = "";
    String desc = "";
    List<String> specs = [];
    Widget sandbox = const SizedBox();

    switch (widget.capabilityId) {
      case 'ai':
        title = tr("تكامل الذكاء الاصطناعي (AI)", "AI Integration");
        desc = tr(
          "نوفر وكلاء أذكياء مدمجين يستجيبون للبيانات الفورية، مع دمج تقنيات RAG وقواعد البيانات المتجهة للبحث الدلالي الفوري.",
          "We build customized, scalable LLM pipelines, vector databases (Pinecone, PGVector), and real-time smart agents."
        );
        specs = [
          tr("محرك استدلال سريع", "Ultra-low latency inference"),
          tr("خطوط RAG وقواعد بيانات متجهة", "Advanced RAG & Vector databases"),
          tr("وكلاء مبرمجون مؤتمتون", "Autonomous workflow agents")
        ];
        sandbox = _buildAiSandbox();
        break;
      case '3d':
        title = tr("تطوير الويب ثلاثي الأبعاد", "3D Web Development");
        desc = tr(
          "نصمم تجارب ويب بصرية سينمائية مجسمة وعروض منتجات تفاعلية ثلاثية الأبعاد خفيفة الوزن على المتصفح.",
          "We deliver high-fidelity spatial configurations, customized WebGL shaders, and optimized asset pipelines."
        );
        specs = [
          tr("تفاعلية 3D بالوقت الفعلي", "Real-time 3D configuration"),
          tr("رسومات WebGL عالية الأداء", "Low-overhead WebGL rendering"),
          tr("تحسين مجسمات Blender", "Blender mesh and asset compression")
        ];
        sandbox = _build3dSandbox();
        break;
      case 'saas':
        title = tr("أنظمة SaaS المخصصة", "Custom SaaS");
        desc = tr(
          "منصات سحابية للمستأجرين المتعددين مهندسة للتوسع ومزودة بأنظمة الدفع والتحليلات المتطورة.",
          "Custom multi-tenant architectures built with automated subscriptions, invoicing, and usage analytics."
        );
        specs = [
          tr("بنية مستأجرين متعددة آمنة", "Secure multi-tenant data silos"),
          tr("نظام فوترة دولي مدمج", "Integrated Stripe & Billing engines"),
          tr("لوحات تحكم وتحليلات ذكية", "Executive analytical dashboards")
        ];
        sandbox = _buildSaasSandbox();
        break;
      case 'security':
        title = tr("الأمن السيبراني والوقاية", "Cyber Security");
        desc = tr(
          "نطبق بنية الثقة الصفرية (Zero-Trust) ونقوم بالتدقيق الأمني الدوري والوقائي لحماية سيرفراتك وقواعد بياناتك.",
          "Bulletproof systems backed by deep threat modeling, access audits, and automatic CDN DDOS mitigation."
        );
        specs = [
          tr("بنية الثقة الصفرية المعتمدة", "Zero-Trust micro-segmentation"),
          tr("تدقيق واختراق أمني وقائي", "Pre-emptive penetration tests"),
          tr("صد هجمات حجب الخدمة DDoS", "DDoS mitigation at global Edge")
        ];
        sandbox = _buildSecuritySandbox();
        break;
      case 'architecture':
        title = tr("بنية تحتية قابلة للتوسع", "Scalable Infrastructure");
        desc = tr(
          "بنية سحابية مرنة تعتمد على Kubernetes وIaC (Terraform) لتتحمل ملايين الزيارات المتزامنة بكفاءة وبأقل تكلفة.",
          "Automated cloud systems utilizing Docker, Kubernetes, autoscaling rules, and infrastructure as code."
        );
        specs = [
          tr("أتمتة البنية التحتية (Terraform)", "Infrastructure as Code (Terraform)"),
          tr("إدارة الحاويات بـ Kubernetes", "Container orchestration via K8s"),
          tr("مراقبة وتحليلات الأداء الفوري", "Real-time Prometheus monitoring")
        ];
        sandbox = _buildArchitectureSandbox();
        break;
      case 'immersive':
        title = tr("تجارب مستخدم تفاعلية (UX)", "Immersive Experiences");
        desc = tr(
          "تصاميم بكسلية مذهلة وواجهات تفاعلية غنية بالرسوم الحركية الدقيقة التي تضفي حيوية على تجربة المستخدم.",
          "Pixel-perfect frontend craft utilizing physics, smooth keyframe curves, and stunning dark glass interfaces."
        );
        specs = [
          tr("واجهات غنية بالحركة الفائقة", "Fluid custom motion models"),
          tr("تصاميم زجاجية Glassmorphism", "Premium glassmorphic themes"),
          tr("تفاعلية ممتازة للهواتف والويب", "Responsive viewport scaling")
        ];
        sandbox = _buildImmersiveSandbox();
        break;
    }

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1152),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button
            CustomCursorHover(
              child: TextButton.icon(
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back, color: Color(0xFF3FD2FF)),
                label: Text(
                  tr('العودة للرئيسية', 'Back to Home'),
                  style: const TextStyle(color: Color(0xFF3FD2FF), fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Two-column layout
            LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 800;
                
                final specWidget = Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFF141A29).withOpacity(0.5),
                    border: Border.all(color: const Color(0xFF3FD2FF).withOpacity(0.15)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr("المواصفات والتقنيات", "Technical Specs"),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3FD2FF)),
                      ),
                      const SizedBox(height: 16),
                      ...specs.map((spec) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          children: [
                            const Icon(Icons.verified, color: Color(0xFF3FD2FF), size: 18),
                            const SizedBox(width: 10),
                            Expanded(child: Text(spec, style: const TextStyle(color: Color(0xFFA6ABB6), fontSize: 14))),
                          ],
                        ),
                      )),
                    ],
                  ),
                );

                final contentCol = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr('// لوحة العرض التفاعلية', '// INTERACTIVE DEMO SANDBOX'),
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                        color: Color(0xFF3FD2FF),
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      desc,
                      style: const TextStyle(color: Color(0xFFA6ABB6), fontSize: 16, height: 1.6),
                    ),
                    const SizedBox(height: 32),
                    
                    // Main Sandbox Card
                    sandbox,
                    
                    if (isMobile) ...[
                      const SizedBox(height: 24),
                      specWidget
                    ]
                  ],
                );

                if (isMobile) {
                  return contentCol;
                } else {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: contentCol),
                      const SizedBox(width: 32),
                      Expanded(flex: 1, child: Padding(
                        padding: const EdgeInsets.only(top: 100.0),
                        child: specWidget,
                      )),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // AI Interactive Sandbox Builder
  // -------------------------------------------------------------
  Widget _buildAiSandbox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0C101B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF3FD2FF).withOpacity(0.2)),
        boxShadow: [
          BoxShadow(color: const Color(0xFF3FD2FF).withOpacity(0.05), blurRadius: 32)
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(tr("الوكيل الذكي: RAG Sandbox", "Smart Agent Console"), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _aiRunning ? Colors.green : Colors.amber,
                  boxShadow: [
                    BoxShadow(color: (_aiRunning ? Colors.green : Colors.amber).withOpacity(0.5), blurRadius: 8)
                  ]
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 140,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CustomPaint(
                painter: AiNeuralNetworkPainter(
                  animationValue: _demoController.value,
                  isRunning: _aiRunning,
                  progress: _aiProgress,
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          DropdownButtonFormField<String>(
            value: _aiSelectedPrompt,
            dropdownColor: const Color(0xFF090D16),
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              labelText: tr("اختر نموذج المهمة", "Select Preset Prompt Task"),
              labelStyle: const TextStyle(color: Color(0xFF3FD2FF)),
              filled: true,
              fillColor: const Color(0xFF090D16),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            items: [
              "Analyze Cloud Usage Patterns",
              "Audit Smart Contracts for Vulnerabilities",
              "Generate Semantic Search Ingress Pipeline",
              "Synthesize SaaS Multi-Tenant Billing Rules"
            ].map((String prompt) {
              return DropdownMenuItem<String>(value: prompt, child: Text(prompt));
            }).toList(),
            onChanged: _aiRunning ? null : (val) {
              if (val != null) setState(() => _aiSelectedPrompt = val);
            },
          ),
          const SizedBox(height: 20),
          CustomCursorHover(
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: TextButton.icon(
                onPressed: _aiRunning ? null : _runAiPipeline,
                style: TextButton.styleFrom(
                  backgroundColor: _aiRunning ? Colors.white12 : const Color(0xFF3FD2FF),
                  foregroundColor: const Color(0xFF090D16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.play_arrow),
                label: Text(_aiRunning ? tr("جاري التشغيل...", "Executing...") : tr("تشغيل خط الإمداد الذكي", "Execute RAG Pipeline")),
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (_aiRunning || _aiConsoleLogs.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                value: _aiProgress,
                backgroundColor: Colors.white10,
                color: const Color(0xFF3FD2FF),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 180,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10)
              ),
              child: ListView.builder(
                itemCount: _aiConsoleLogs.length,
                itemBuilder: (context, idx) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      _aiConsoleLogs[idx],
                      style: const TextStyle(fontFamily: 'monospace', color: Color(0xFF3FD2FF), fontSize: 13),
                    ),
                  );
                },
              ),
            )
          ]
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // 3D Customizer Sandbox Builder
  // -------------------------------------------------------------
  Widget _build3dSandbox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0C101B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF3FD2FF).withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(tr("تخصيص الرسوم ثلاثية الأبعاد التفاعلية", "Real-Time 3D Interactive Mesh"), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              Row(
                children: [
                  _colorDot(const Color(0xFF3FD2FF)),
                  const SizedBox(width: 8),
                  _colorDot(const Color(0xFFAD00FF)),
                  const SizedBox(width: 8),
                  _colorDot(const Color(0xFFFF3F80)),
                ],
              )
            ],
          ),
          const SizedBox(height: 20),
          // Interactive Custom Canvas
          Container(
            height: 240,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10)
            ),
            child: ClipRect(
              child: Particle3DCanvas(
                speed: _particleSpeed,
                count: _particleCount,
                color: _particleColor,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Sliders
          Row(
            children: [
              Text(tr("السرعة", "Speed"), style: const TextStyle(color: Colors.white, fontSize: 13)),
              Expanded(
                child: Slider(
                  value: _particleSpeed,
                  min: 0.1,
                  max: 3.0,
                  activeColor: const Color(0xFF3FD2FF),
                  inactiveColor: Colors.white10,
                  onChanged: (val) => setState(() => _particleSpeed = val),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(tr("الكمية", "Density"), style: const TextStyle(color: Colors.white, fontSize: 13)),
              Expanded(
                child: Slider(
                  value: _particleCount,
                  min: 10,
                  max: 120,
                  activeColor: const Color(0xFF3FD2FF),
                  inactiveColor: Colors.white10,
                  onChanged: (val) => setState(() => _particleCount = val),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _colorDot(Color color) {
    return GestureDetector(
      onTap: () => setState(() => _particleColor = color),
      child: CustomCursorHover(
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: _particleColor == color ? Colors.white : Colors.transparent,
              width: 2.0
            )
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // SaaS Dashboard Sandbox Builder
  // -------------------------------------------------------------
  Widget _buildSaasSandbox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0C101B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF3FD2FF).withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(tr("محاكاة تحليلات SaaS الفورية", "Live SaaS Analytics Control"), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              if (_saasPeakActive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.redAccent)
                  ),
                  child: Text(tr("ذروة ترافيك", "PEAK TRAFFIC"), style: const TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                )
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 120,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CustomPaint(
                painter: SaasTransactionFlowPainter(
                  animation: _demoController.value,
                  apiRate: _saasApiRate,
                  peakActive: _saasPeakActive,
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          // Metrics Cards Grid
          GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width < 600 ? 1 : 3,
            shrinkWrap: true,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.8,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _metricItem(tr("المشتركون النشطون", "Active Tenants"), _saasUsers.toString(), Icons.people),
              _metricItem(tr("الإيرادات الشهرية المتكررة", "MRR (\$)" ), "\$${_saasMrr.toStringAsFixed(0)}", Icons.monetization_on),
              _metricItem(tr("معدل استدعاء API / ثانية", "API Requests/s"), "${_saasApiRate} req/s", Icons.speed),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: CustomCursorHover(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _saasUsers += 1;
                        _saasMrr += 49.0;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(tr("تم بيع اشتراك جديد بقيمة 49\$/شهرياً!", "New subscription sold for \$49/mo!")),
                          backgroundColor: const Color(0xFF3FD2FF),
                          duration: const Duration(seconds: 1),
                        )
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF3FD2FF).withOpacity(0.1),
                      foregroundColor: const Color(0xFF3FD2FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Color(0xFF3FD2FF))
                      ),
                    ),
                    child: Text(tr("+ بيع اشتراك SaaS", "+ Acquire SaaS Tenant")),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomCursorHover(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _saasPeakActive = !_saasPeakActive;
                        _saasApiRate = _saasPeakActive ? 4200 : 180;
                      });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: _saasPeakActive ? Colors.redAccent.withOpacity(0.2) : Colors.white10,
                      foregroundColor: _saasPeakActive ? Colors.redAccent : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: _saasPeakActive ? Colors.redAccent : Colors.white24)
                      ),
                    ),
                    child: Text(_saasPeakActive ? tr("إيقاف المحاكاة", "Mitigate Surge") : tr("محاكاة ضغط شبكة", "Simulate Traffic Spike")),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _metricItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF3FD2FF), size: 18),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: Color(0xFFA6ABB6), fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // Cyber Security Sandbox Builder
  // -------------------------------------------------------------
  Widget _buildSecuritySandbox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0C101B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF3FD2FF).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(tr("مركز عمليات الأمن والتحكم (SOC)", "Security Operations Center Console"), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              CustomCursorHover(
                child: TextButton.icon(
                  onPressed: _scanningActive ? null : _runSecurityScan,
                  icon: const Icon(Icons.security, size: 18),
                  label: Text(_scanningActive ? tr("جاري الفحص...", "Scanning...") : tr("فحص الأمان الوقائي", "Audit Security Status")),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF3FD2FF),
                    foregroundColor: const Color(0xFF090D16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 150,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CustomPaint(
                painter: SecurityRadarDefensePainter(
                  animationValue: _demoController.value,
                  isScanning: _scanningActive,
                  radarAngle: _radarAngle,
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          // Radar/Log section
          Row(
            children: [
              if (_scanningActive) ...[
                Container(
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  child: RotationTransition(
                    turns: AlwaysStoppedAnimation(_radarAngle),
                    child: const Icon(Icons.radar, color: Color(0xFF3FD2FF), size: 48),
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: Text(
                  _scanningActive 
                      ? tr("جاري مسح المنافذ وفحص سلامة التشفير...", "Auditing ingress routes & scanning endpoints...")
                      : tr("الحالة الأمنية: محمي 100% (جميع جدران الحماية فعالة)", "SOC Status: Active Defense. Firewall systems green."),
                  style: TextStyle(color: _scanningActive ? const Color(0xFF3FD2FF) : Colors.greenAccent, fontSize: 13),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 180,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10)
            ),
            child: ListView.builder(
              itemCount: _securityEvents.length,
              itemBuilder: (context, idx) {
                final ev = _securityEvents[idx];
                final isSuccess = ev['type'] == 'SUCCESS';
                final isMitigated = ev['type'] == 'MITIGATED';
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Text("[${ev['time']}] ", style: const TextStyle(fontFamily: 'monospace', color: Colors.white30, fontSize: 12)),
                      Text(
                        isSuccess ? "[OK] " : isMitigated ? "[BLOCKED] " : "[INFO] ",
                        style: TextStyle(
                          fontFamily: 'monospace', 
                          color: isSuccess ? Colors.green : isMitigated ? Colors.redAccent : Colors.cyan,
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Expanded(
                        child: Text(
                          tr(ev['msgAr']!, ev['msgEn']!),
                          style: const TextStyle(fontFamily: 'monospace', color: Colors.white70, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // Infrastructure Orchestrator Sandbox Builder
  // -------------------------------------------------------------
  Widget _buildArchitectureSandbox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0C101B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF3FD2FF).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(tr("منسق الخوادم السحابية والأحمال", "Orchestration & Kubernetes Nodes"), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              Row(
                children: [
                  CustomCursorHover(
                    child: IconButton(
                      icon: const Icon(Icons.remove_circle_outline, color: Colors.white70),
                      onPressed: _replicaCount > 1 ? () => setState(() => _replicaCount--) : null,
                    ),
                  ),
                  Text(_replicaCount.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  CustomCursorHover(
                    child: IconButton(
                      icon: const Icon(Icons.add_circle_outline, color: Colors.white70),
                      onPressed: _replicaCount < 6 ? () => setState(() => _replicaCount++) : null,
                    ),
                  ),
                  Text(tr("سيرفرات فرعية", "Replicas"), style: const TextStyle(color: Color(0xFFA6ABB6), fontSize: 13)),
                ],
              )
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 120,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CustomPaint(
                painter: K8sClusterPainter(
                  animation: _demoController.value,
                  replicas: _replicaCount,
                  stressTest: _stressTestRunning,
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          // Infrastructure Nodes view
          Container(
            height: 180,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10)
            ),
            child: GridView.builder(
              itemCount: _replicaCount + 1, // +1 for Load Balancer
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width < 500 ? 2 : 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.2,
              ),
              itemBuilder: (context, idx) {
                if (idx == 0) {
                  return _nodeCard(tr("موجه الأحمال", "Load Balancer"), Colors.purpleAccent, true);
                }
                Color statusColor = Colors.greenAccent;
                if (_stressTestRunning) {
                  statusColor = _replicaCount < 4 ? Colors.redAccent : Colors.orangeAccent;
                }
                return _nodeCard(tr("سيرفر ${idx}", "Node ${idx}"), statusColor, false);
              },
            ),
          ),
          const SizedBox(height: 20),
          CustomCursorHover(
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: TextButton.icon(
                onPressed: _toggleStressTest,
                icon: const Icon(Icons.bolt),
                style: TextButton.styleFrom(
                  backgroundColor: _stressTestRunning ? Colors.redAccent.withOpacity(0.2) : const Color(0xFF3FD2FF),
                  foregroundColor: _stressTestRunning ? Colors.redAccent : const Color(0xFF090D16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                label: Text(_stressTestRunning ? tr("إيقاف فحص الضغط المرتفع", "Stop Load Balancer Stress Test") : tr("بدء فحص الضغط المرتفع", "Launch Load Balancer Stress Test")),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _nodeCard(String name, Color color, bool isLb) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isLb ? Colors.black54 : const Color(0xFF141A29),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.6), width: 1.5),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.1), blurRadius: 8)
        ]
      ),
      child: Row(
        children: [
          Icon(isLb ? Icons.router : Icons.dns, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                Text(isLb ? tr("نشط", "ROUTING") : _stressTestRunning ? tr("ضغط عالي", "HIGH LOAD") : tr("سليم", "HEALTHY"), style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w600)),
              ],
            ),
          )
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // Immersive Experience (Physics Sandbox) Builder
  // -------------------------------------------------------------
  Widget _buildImmersiveSandbox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0C101B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF3FD2FF).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(tr("محاكي الحركة والفيزياء (انقر بالأسفل لإلقاء الكرات)", "Interactive Physics & Gravitational Sandbox"), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              CustomCursorHover(
                child: TextButton(
                  onPressed: () => setState(() => _balls.clear()),
                  style: TextButton.styleFrom(foregroundColor: const Color(0xFF3FD2FF)),
                  child: Text(tr("تفريغ الشاشة", "Clear Canvas")),
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          // Interactive physics screen
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 250,
              width: double.infinity,
              color: Colors.black45,
              child: PhysicsSandboxCanvas(
                balls: _balls,
                onTapDown: (offset) {
                  // Add a new ball
                  setState(() {
                    _balls.add(
                      PhysicsBall(
                        x: offset.dx,
                        y: offset.dy,
                        vx: (offset.dx % 6) - 3,
                        vy: -4,
                        radius: 12 + (offset.dy % 10),
                        color: _particleColor
                      )
                    );
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// Interactive helper Widgets & Canvas Painters
// -------------------------------------------------------------

class Particle3DCanvas extends StatefulWidget {
  final double speed;
  final double count;
  final Color color;

  const Particle3DCanvas({
    super.key,
    required this.speed,
    required this.count,
    required this.color,
  });

  @override
  State<Particle3DCanvas> createState() => _Particle3DCanvasState();
}

class _Particle3DCanvasState extends State<Particle3DCanvas> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  double _angle = 0.0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 10))
      ..addListener(() {
        setState(() {
          _angle += 0.01 * widget.speed;
        });
      })
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: Particle3DPainter(angle: _angle, density: widget.count.toInt(), color: widget.color),
      child: const SizedBox.expand(),
    );
  }
}

class Particle3DPainter extends CustomPainter {
  final double angle;
  final int density;
  final Color color;

  Particle3DPainter({required this.angle, required this.density, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final paint = Paint()
      ..color = color.withOpacity(0.8)
      ..strokeWidth = 2.0;

    // Precompute simple orbits
    for (int i = 0; i < density; i++) {
      double t = (i / density) * 2 * 3.14159;
      // 3D coordinates
      double x = 120 * double.parse((t).toString()).hashCode % 100 * 0.8 * double.parse((t + angle).toString()).hashCode % 2 == 0 
          ? 100 * (t + angle).hashCode % 120 * 0.5 
          : 90 * (t + angle).hashCode % 110 * 0.4;
      
      // Calculate rotating circle orbits
      double rad = 70.0 + 30.0 * (i % 3);
      double curAngle = t + angle * (1 + (i % 2) * 0.5);
      
      double px = rad * (1.0 + 0.1 * (i % 4));
      double py = rad * (1.0 + 0.15 * (i % 3));
      
      double rx = cx + px * (0.8 * (rad % 2 == 0 ? 1 : -1)) * (1.2 * (i % 2 == 0 ? 1 : -1)) * (0.8 + 0.2 * (i % 3));
      double ry = cy + py * (0.5 * (rad % 3 == 0 ? 1 : -1)) * (1.1 * (i % 3 == 0 ? 1 : -1)) * (0.7 + 0.3 * (i % 2));
      
      double dx = cx + rad * (rad % 2 == 0 ? 1 : -1) * (i % 3 == 0 ? 1 : -1) * (0.7 + 0.3 * (i % 2));
      double dy = cy + rad * (rad % 3 == 0 ? 1 : -1) * (i % 2 == 0 ? 1 : -1) * (0.8 + 0.2 * (i % 3));
      
      // Simplified trigonometry orbits
      double sinVal = (curAngle).hashCode % 100 / 100.0;
      double cosVal = (curAngle + 1.5).hashCode % 100 / 100.0;
      
      double ox = cx + rad * sinVal * (i % 2 == 0 ? 1.0 : -1.0);
      double oy = cy + rad * cosVal * (i % 3 == 0 ? 0.6 : -0.6);
      
      canvas.drawCircle(Offset(ox, oy), 2.5 + (i % 3), paint);
      
      // Draw light orbital wireframe links
      if (i > 0 && i % 8 == 0) {
        final linePaint = Paint()
          ..color = color.withOpacity(0.12)
          ..strokeWidth = 1.0;
        canvas.drawLine(Offset(cx, cy), Offset(ox, oy), linePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant Particle3DPainter oldDelegate) => true;
}

// Physics engine components
class PhysicsBall {
  double x, y;
  double vx, vy;
  double radius;
  Color color;

  PhysicsBall({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.radius,
    required this.color,
  });
}

class PhysicsSandboxCanvas extends StatefulWidget {
  final List<PhysicsBall> balls;
  final Function(Offset) onTapDown;

  const PhysicsSandboxCanvas({
    super.key,
    required this.balls,
    required this.onTapDown,
  });

  @override
  State<PhysicsSandboxCanvas> createState() => _PhysicsSandboxCanvasState();
}

class _PhysicsSandboxCanvasState extends State<PhysicsSandboxCanvas> with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  Offset? _gravityNode;
  double _pulseAnim = 0.0;
  double _pulseDir = 1.0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((_) {
      _updatePhysics();
    })..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _updatePhysics() {
    if (!mounted) return;
    const double gravity = 0.22;
    const double friction = 0.99;
    const double bounce = 0.72;

    setState(() {
      _pulseAnim += 0.03 * _pulseDir;
      if (_pulseAnim > 1.0 || _pulseAnim < 0.0) {
        _pulseDir = -_pulseDir;
      }

      for (var ball in widget.balls) {
        if (_gravityNode != null) {
          // Gravitational pull calculation
          double dx = _gravityNode!.dx - ball.x;
          double dy = _gravityNode!.dy - ball.y;
          double dist = sqrt(dx * dx + dy * dy);
          if (dist > 10) {
            double force = 12.0 / (dist * 0.015 + 1.0);
            ball.vx += (dx / dist) * force;
            ball.vy += (dy / dist) * force;
          }
        } else {
          ball.vy += gravity;
        }

        ball.vx *= friction;
        ball.vy *= friction;

        ball.x += ball.vx;
        ball.y += ball.vy;

        // Wall collisions
        const width = 800.0;
        const height = 250.0;

        if (ball.x - ball.radius < 0) {
          ball.x = ball.radius;
          ball.vx = -ball.vx * bounce;
        } else if (ball.x + ball.radius > width) {
          ball.x = width - ball.radius;
          ball.vx = -ball.vx * bounce;
        }

        if (ball.y - ball.radius < 0) {
          ball.y = ball.radius;
          ball.vy = -ball.vy * bounce;
        } else if (ball.y + ball.radius > height) {
          ball.y = height - ball.radius;
          ball.vy = -ball.vy * bounce;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        setState(() => _gravityNode = details.localPosition);
      },
      onPanUpdate: (details) {
        setState(() => _gravityNode = details.localPosition);
      },
      onPanEnd: (_) {
        setState(() => _gravityNode = null);
      },
      onPanCancel: () {
        setState(() => _gravityNode = null);
      },
      onTapDown: (details) {
        if (_gravityNode == null) {
          widget.onTapDown(details.localPosition);
        }
      },
      child: CustomPaint(
        painter: PhysicsSandboxPainter(
          balls: widget.balls,
          gravityNode: _gravityNode,
          pulse: _pulseAnim,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class PhysicsSandboxPainter extends CustomPainter {
  final List<PhysicsBall> balls;
  final Offset? gravityNode;
  final double pulse;

  PhysicsSandboxPainter({
    required this.balls,
    this.gravityNode,
    this.pulse = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final attColor = const Color(0xFFAD00FF);

    // Draw gravity node (black hole)
    if (gravityNode != null) {
      for (int i = 1; i <= 3; i++) {
        final r = (18.0 * i) + (pulse * 8.0);
        canvas.drawCircle(
          gravityNode!,
          r,
          Paint()
            ..color = attColor.withOpacity(0.12 / i)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );
      }

      // Glow blur
      canvas.drawCircle(
        gravityNode!,
        25,
        Paint()
          ..color = attColor.withOpacity(0.25)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
      );

      // Core
      canvas.drawCircle(gravityNode!, 10, Paint()..color = Colors.black);
      canvas.drawCircle(
        gravityNode!,
        10,
        Paint()
          ..color = attColor.withOpacity(0.9)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0,
      );
    }

    for (var ball in balls) {
      final paint = Paint()
        ..color = ball.color
        ..style = PaintingStyle.fill;

      // Glow shadow
      canvas.drawCircle(
        Offset(ball.x, ball.y),
        ball.radius,
        Paint()
          ..color = ball.color.withOpacity(0.25)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );

      canvas.drawCircle(Offset(ball.x, ball.y), ball.radius, paint);

      // Spark highlight
      final highlight = Paint()..color = Colors.white.withOpacity(0.5);
      canvas.drawCircle(
        Offset(ball.x - ball.radius / 3, ball.y - ball.radius / 3),
        ball.radius / 4.5,
        highlight,
      );
    }
  }

  @override
  bool shouldRepaint(covariant PhysicsSandboxPainter oldDelegate) => true;
}

// -------------------------------------------------------------
// Interactive Capability Custom Painters
// -------------------------------------------------------------

class AiNeuralNetworkPainter extends CustomPainter {
  final double animationValue;
  final bool isRunning;
  final double progress;

  AiNeuralNetworkPainter({
    required this.animationValue,
    required this.isRunning,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final paint = Paint()
      ..color = const Color(0xFF3FD2FF).withOpacity(0.2)
      ..strokeWidth = 1.0;

    final nodes = [
      Offset(cx - 200, cy - 35),
      Offset(cx - 200, cy + 35),
      Offset(cx - 80, cy - 45),
      Offset(cx - 80, cy + 0),
      Offset(cx - 80, cy + 45),
      Offset(cx + 80, cy - 45),
      Offset(cx + 80, cy + 0),
      Offset(cx + 80, cy + 45),
      Offset(cx + 200, cy - 25),
      Offset(cx + 200, cy + 25),
    ];

    final connections = [
      [0, 2], [0, 3], [1, 3], [1, 4],
      [2, 5], [2, 6], [3, 6], [4, 6], [4, 7],
      [5, 8], [6, 8], [6, 9], [7, 9]
    ];

    for (var conn in connections) {
      canvas.drawLine(nodes[conn[0]], nodes[conn[1]], paint);
    }

    if (isRunning) {
      final signalPaint = Paint()
        ..color = const Color(0xFF3FD2FF)
        ..style = PaintingStyle.fill;
      for (var conn in connections) {
        final start = nodes[conn[0]];
        final end = nodes[conn[1]];
        final t = (animationValue * 4.0 + conn[0] * 0.2) % 1.0;
        final x = start.dx + (end.dx - start.dx) * t;
        final y = start.dy + (end.dy - start.dy) * t;
        canvas.drawCircle(Offset(x, y), 2.5, signalPaint);
      }
    }

    for (int i = 0; i < nodes.length; i++) {
      final n = nodes[i];
      final nodeGlow = Paint()
        ..color = const Color(0xFF3FD2FF).withOpacity(0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
      canvas.drawCircle(n, 6 + sin(animationValue * 6.28 + i) * 1.5, nodeGlow);

      final nodePaint = Paint()
        ..color = isRunning ? const Color(0xFF3FD2FF) : const Color(0xFF141A29)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(n, 4.5, nodePaint);

      final borderPaint = Paint()
        ..color = const Color(0xFF3FD2FF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2;
      canvas.drawCircle(n, 4.5, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant AiNeuralNetworkPainter oldDelegate) => true;
}

class SaasTransactionFlowPainter extends CustomPainter {
  final double animation;
  final int apiRate;
  final bool peakActive;

  SaasTransactionFlowPainter({
    required this.animation,
    required this.apiRate,
    required this.peakActive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final color = const Color(0xFF3FD2FF);
    final accent = const Color(0xFFAD00FF);

    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.015)
      ..strokeWidth = 1.0;
    for (double x = 0; x < w; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, h), gridPaint);
    }
    for (double y = 0; y < h; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
    }

    final coreGlow = Paint()
      ..color = color.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(Offset(w / 2, h / 2), 20, coreGlow);

    final corePaint = Paint()
      ..color = const Color(0xFF141A29)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w / 2, h / 2), 14, corePaint);

    final coreBorder = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    canvas.drawCircle(Offset(w / 2, h / 2), 14, coreBorder);

    final lanePaint = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final leftNodes = [Offset(40, h * 0.25), Offset(40, h * 0.5), Offset(40, h * 0.75)];
    final rightNodes = [Offset(w - 40, h * 0.3), Offset(w - 40, h * 0.7)];

    for (var lNode in leftNodes) {
      final path = Path()
        ..moveTo(lNode.dx, lNode.dy)
        ..cubicTo(w * 0.25, lNode.dy, w * 0.25, h / 2, w / 2, h / 2);
      canvas.drawPath(path, lanePaint);

      final pulseSpeed = peakActive ? 7.0 : 2.5;
      final t = (animation * pulseSpeed + lNode.dy * 0.01) % 1.0;
      final offset = _getPathOffset(path, t);
      canvas.drawCircle(offset, 2.5, Paint()..color = color);
    }

    for (var rNode in rightNodes) {
      final path = Path()
        ..moveTo(w / 2, h / 2)
        ..cubicTo(w * 0.75, h / 2, w * 0.75, rNode.dy, rNode.dx, rNode.dy);
      canvas.drawPath(path, lanePaint);

      final pulseSpeed = peakActive ? 7.0 : 2.5;
      final t = (animation * pulseSpeed + rNode.dy * 0.01) % 1.0;
      final offset = _getPathOffset(path, t);
      canvas.drawCircle(offset, 4.0, Paint()..color = peakActive ? Colors.redAccent : accent);
    }
  }

  Offset _getPathOffset(Path path, double t) {
    final metrics = path.computeMetrics();
    if (metrics.isEmpty) return Offset.zero;
    final metric = metrics.first;
    final length = metric.length;
    final tangent = metric.getTangentForOffset(length * t);
    return tangent?.position ?? Offset.zero;
  }

  @override
  bool shouldRepaint(covariant SaasTransactionFlowPainter oldDelegate) => true;
}

class SecurityRadarDefensePainter extends CustomPainter {
  final double animationValue;
  final bool isScanning;
  final double radarAngle;

  SecurityRadarDefensePainter({
    required this.animationValue,
    required this.isScanning,
    required this.radarAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h / 2;
    final activeColor = const Color(0xFF3FD2FF);

    final linePaint = Paint()
      ..color = activeColor.withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    for (double r = 30; r < w; r += 30) {
      canvas.drawCircle(Offset(cx, cy), r, linePaint);
    }

    canvas.drawLine(Offset(0, cy), Offset(w, cy), linePaint);
    canvas.drawLine(Offset(cx, 0), Offset(cx, h), linePaint);

    final sweepAngle = isScanning ? radarAngle * 6.28 : animationValue * 6.28;
    final endX = cx + cos(sweepAngle) * w;
    final endY = cy + sin(sweepAngle) * w;
    final sweepPaint = Paint()
      ..color = activeColor.withOpacity(0.25)
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(cx, cy), Offset(endX, endY), sweepPaint);

    canvas.drawCircle(
      Offset(cx, cy),
      12,
      Paint()
        ..color = activeColor.withOpacity(0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    canvas.drawCircle(Offset(cx, cy), 6, Paint()..color = activeColor);

    final threatPaint = Paint()
      ..color = Colors.redAccent
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 4; i++) {
      double t = (animationValue * 1.8 + i * 0.25) % 1.0;
      double angle = i * 1.57 + 0.5;
      double distance = 130 * (1.0 - t);
      if (distance > 12) {
        double px = cx + cos(angle) * distance;
        double py = cy + sin(angle) * distance;
        canvas.drawCircle(Offset(px, py), 3, threatPaint);

        canvas.drawCircle(
          Offset(px, py),
          6,
          Paint()..color = Colors.redAccent.withOpacity(0.2)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
        );
      } else {
        canvas.drawLine(
          Offset(cx, cy),
          Offset(cx + cos(angle) * 25, cy + sin(angle) * 25),
          Paint()..color = Colors.yellowAccent..strokeWidth = 1.5,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant SecurityRadarDefensePainter oldDelegate) => true;
}

class K8sClusterPainter extends CustomPainter {
  final double animation;
  final int replicas;
  final bool stressTest;

  K8sClusterPainter({
    required this.animation,
    required this.replicas,
    required this.stressTest,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h / 2;

    final lbPos = Offset(cx, cy);
    final lbGlow = Paint()
      ..color = Colors.purpleAccent.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(lbPos, 18, lbGlow);
    canvas.drawCircle(lbPos, 11, Paint()..color = const Color(0xFF141A29));
    canvas.drawCircle(lbPos, 11, Paint()..color = Colors.purpleAccent..style = PaintingStyle.stroke..strokeWidth = 1.8);

    final podPaint = Paint()
      ..color = const Color(0xFF141A29)
      ..style = PaintingStyle.fill;
    final podBorder = Paint()
      ..color = stressTest ? Colors.orangeAccent : const Color(0xFF3FD2FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    for (int i = 0; i < replicas; i++) {
      double angle = (i / replicas) * 6.28 + (animation * 0.15);
      double dist = 45.0;
      double px = cx + cos(angle) * dist;
      double py = cy + sin(angle) * dist;
      final podPos = Offset(px, py);

      final connPaint = Paint()
        ..color = (stressTest ? Colors.orangeAccent : const Color(0xFF3FD2FF)).withOpacity(0.15)
        ..strokeWidth = 1.0;
      canvas.drawLine(lbPos, podPos, connPaint);

      final packetT = (animation * (stressTest ? 5.5 : 2.2) + i * 0.35) % 1.0;
      final packetX = lbPos.dx + (podPos.dx - lbPos.dx) * packetT;
      final packetY = lbPos.dy + (podPos.dy - lbPos.dy) * packetT;
      canvas.drawCircle(
        Offset(packetX, packetY),
        2.5,
        Paint()..color = stressTest ? Colors.redAccent : const Color(0xFF3FD2FF),
      );

      canvas.drawCircle(
        podPos,
        8,
        Paint()
          ..color = (stressTest ? Colors.orangeAccent : const Color(0xFF3FD2FF)).withOpacity(0.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
      canvas.drawCircle(podPos, 5.5, podPaint);
      canvas.drawCircle(podPos, 5.5, podBorder);
    }
  }

  @override
  bool shouldRepaint(covariant K8sClusterPainter oldDelegate) => true;
}

