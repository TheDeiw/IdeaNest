import 'package:flutter/material.dart';

class EditTagScreen extends StatefulWidget {
  final String tagName;
  final Color tagColor;
  final Color tagBackgroundColor;
  final Color tagBorderColor;

  const EditTagScreen({
    super.key,
    required this.tagName,
    required this.tagColor,
    required this.tagBackgroundColor,
    required this.tagBorderColor,
  });

  @override
  State<EditTagScreen> createState() => _EditTagScreenState();
}

class _EditTagScreenState extends State<EditTagScreen> {
  late TextEditingController _nameController;
  late Color _selectedColor;
  late Color _selectedBgColor;
  late Color _selectedBorderColor;

  // Updated color palette matching the design
  final List<Map<String, dynamic>> _colorOptions = [
    {
      'name': 'Blue',
      'color': const Color(0xFF3B82F6),
      'bgColor': const Color(0xFFBEDBFF),
      'borderColor': const Color(0xFFBEDBFF)
    },
    {
      'name': 'Green',
      'color': const Color(0xFF10B981),
      'bgColor': const Color(0xFFA7F3D0),
      'borderColor': const Color(0xFFA7F3D0)
    },
    {
      'name': 'Purple',
      'color': const Color(0xFF8B5CF6),
      'bgColor': const Color(0xFFEDE9FE),
      'borderColor': const Color(0xFFDDD6FF)
    },
    {
      'name': 'Orange',
      'color': const Color(0xFFF97316),
      'bgColor': const Color(0xFFFFD6A7),
      'borderColor': const Color(0xFFFFD6A7)
    },
    {
      'name': 'Yellow',
      'color': const Color(0xFFEAB308),
      'bgColor': const Color(0xFFFEF9C2),
      'borderColor': const Color(0xFFFFF085)
    },
    {
      'name': 'Indigo',
      'color': const Color(0xFF6366F1),
      'bgColor': const Color(0xFFA9BCFF),
      'borderColor': const Color(0xFFC6D2FF)
    },
    {
      'name': 'Pink',
      'color': const Color(0xFFEC4899),
      'bgColor': const Color(0xFFFCE7F3),
      'borderColor': const Color(0xFFFCCEE8)
    },
    {
      'name': 'Cyan',
      'color': const Color(0xFF06B6D4),
      'bgColor': const Color(0xFFCEFAFE),
      'borderColor': const Color(0xFFA2F4FD)
    },
    {
      'name': 'Teal',
      'color': const Color(0xFF14B8A6),
      'bgColor': const Color(0xFFCBFBF1),
      'borderColor': const Color(0xFF96F7E4)
    },
    {
      'name': 'Lime',
      'color': const Color(0xFF84CC16),
      'bgColor': const Color(0xFFECFCCA),
      'borderColor': const Color(0xFFD8F999)
    },
    {
      'name': 'Emerald',
      'color': const Color(0xFF059669),
      'bgColor': const Color(0xFFD0FAE5),
      'borderColor': const Color(0xFFA4F4CF)
    },
    {
      'name': 'Violet',
      'color': const Color(0xFF7C3AED),
      'bgColor': const Color(0xFFF3E8FF),
      'borderColor': const Color(0xFFE9D4FF)
    },
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.tagName);
    _selectedColor = widget.tagColor;
    _selectedBgColor = widget.tagBackgroundColor;
    _selectedBorderColor = widget.tagBorderColor;

    _nameController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.5),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(7),
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFFCAC4D0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.tagName.isEmpty ? 'Add Tag' : 'Edit Tag',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1D1B20),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Change the name and color of your tag. This will update the tag across all your notes.',
                    textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF49454F),
              ),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: const [
                  Icon(Icons.tag, size: 16, color: Color(0xFF1D1B20)),
                  SizedBox(width: 8),
                  Text(
                    'Tag Name',
                          style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1D1B20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextField(
                    controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Enter tag name',
                filled: true,
                fillColor: Color(0xFFF3F3F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: const [
                  Icon(Icons.palette, size: 16, color: Color(0xFF1D1B20)),
                  SizedBox(width: 8),
                  Text(
                    'Color',
                          style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1D1B20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
                    shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.8,
              ),
              itemCount: _colorOptions.length,
              itemBuilder: (context, index) {
                      final colorOption = _colorOptions[index];
                final bool isSelected = colorOption['color'] == _selectedColor;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = colorOption['color'] as Color;
                      _selectedBgColor = colorOption['bgColor'] as Color;
                      _selectedBorderColor = colorOption['borderColor'] as Color;
                    });
                  },
                  child: Container(
                          decoration: BoxDecoration(
                      color: (colorOption['bgColor'] as Color).withValues(alpha: 0.13),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF101828) : Colors.grey[200]!,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                              Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: colorOption['color'] as Color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        if (isSelected)
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF101828),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Preview',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1D1B20),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
                    padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Chip(
                    label: Text(
                      _nameController.text.isEmpty ? 'Tag name' : _nameController.text,
                      style: TextStyle(
                        color: _selectedColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    backgroundColor: _selectedBgColor,
                    shape: StadiumBorder(
                      side: BorderSide(color: _selectedBorderColor),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'in your notes',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4A5565),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
                    children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFCAC4D0)),
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1D1B20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Save changes
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF101828),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (widget.tagName.isNotEmpty) ...[
                    const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: Delete tag
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.delete_outline, size: 16),
                label: const Text('Delete Tag'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFBA1A1A),
                  side: const BorderSide(color: Color(0xFFBA1A1A)),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  minimumSize: const Size(double.infinity, 36),
                ),
              ),
            ],
          ],
        ),
      ),
      ),
    );
  }
}

