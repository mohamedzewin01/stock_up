// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:stock_up/core/resources/style_manager.dart';
// import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';
// import 'package:stock_up/features/Home/presentation/widgets/profile_dialog.dart';
// import 'package:stock_up/features/Stores/data/models/response/all_stores_model.dart';
// import 'package:stock_up/features/Stores/presentation/bloc/Stores_cubit.dart';
//
// class DashboardHeaderSection extends StatefulWidget {
//   final VoidCallback onStoreChanged;
//   final DateTime selectedDate;
//   final Function(DateTime) onDateChanged;
//
//   const DashboardHeaderSection({
//     super.key,
//     required this.onStoreChanged,
//     required this.selectedDate,
//     required this.onDateChanged,
//   });
//
//   @override
//   State<DashboardHeaderSection> createState() => _DashboardHeaderSectionState();
// }
//
// class _DashboardHeaderSectionState extends State<DashboardHeaderSection> {
//   Results? selectedStore;
//
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final width = constraints.maxWidth;
//
//         if (width < 600) {
//           return _buildMobileHeader(context);
//         } else {
//           return _buildDesktopHeader(context);
//         }
//       },
//     );
//   }
//
//   Widget _buildMobileHeader(BuildContext context) {
//     final userName =
//         CacheService.getData(key: CacheKeys.userName) ?? 'المستخدم';
//
//     return Container(
//       margin: const EdgeInsets.all(8),
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           begin: Alignment.topRight,
//           end: Alignment.bottomLeft,
//           colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF6366F1).withOpacity(0.3),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // Row 1: User Info + Actions
//           Row(
//             children: [
//               // User Avatar
//               GestureDetector(
//                 onTap: () => _showProfileDialog(context),
//                 child: Container(
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color: Colors.white.withOpacity(0.5),
//                       width: 2,
//                     ),
//                   ),
//                   child: const Icon(
//                     Icons.person_rounded,
//                     size: 26,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//
//               // User Info
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text(
//                         'مرحباً،',
//                         style: getRegularStyle(
//                           color: Colors.white.withOpacity(0.9),
//                           fontSize: 12,
//                         ),
//                       ),
//                       Text(
//                         userName,
//                         style: getBoldStyle(color: Colors.white, fontSize: 18),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // Notification Button
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: IconButton(
//                   icon: Stack(
//                     children: [
//                       const Icon(
//                         Icons.notifications_rounded,
//                         color: Colors.white,
//                         size: 22,
//                       ),
//                       Positioned(
//                         top: 0,
//                         right: 0,
//                         child: Container(
//                           width: 7,
//                           height: 7,
//                           decoration: const BoxDecoration(
//                             color: Color(0xFFEF4444),
//                             shape: BoxShape.circle,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   onPressed: () => _showNotificationSnackBar(context),
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 12),
//
//           // Store Selector & Date Picker Row
//           Row(
//             children: [
//               // Date Picker
//               Expanded(child: _buildDatePicker(context)),
//               const SizedBox(width: 4),
//               // Store Selector
//               Expanded(child: _buildStoreSelector(context)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDesktopHeader(BuildContext context) {
//     final userName =
//         CacheService.getData(key: CacheKeys.userName) ?? 'المستخدم';
//
//     return Container(
//       margin: const EdgeInsets.all(20),
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           begin: Alignment.topRight,
//           end: Alignment.bottomLeft,
//           colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFA855F7)],
//         ),
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF6366F1).withOpacity(0.3),
//             blurRadius: 30,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // Row 1: Avatar + User Info + Actions
//           Row(
//             children: [
//               // User Avatar
//               GestureDetector(
//                 onTap: () => _showProfileDialog(context),
//                 child: Container(
//                   width: 70,
//                   height: 70,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color: Colors.white.withOpacity(0.5),
//                       width: 3,
//                     ),
//                   ),
//                   child: const Icon(
//                     Icons.person_rounded,
//                     size: 35,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//
//               // User Info
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(
//                       'مرحباً بعودتك،',
//                       style: getRegularStyle(
//                         color: Colors.white.withOpacity(0.9),
//                         fontSize: 14,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       userName,
//                       style: getBoldStyle(color: Colors.white, fontSize: 22),
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Notification Button
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: IconButton(
//                   icon: Stack(
//                     children: [
//                       const Icon(
//                         Icons.notifications_rounded,
//                         color: Colors.white,
//                         size: 22,
//                       ),
//                       Positioned(
//                         top: 0,
//                         right: 0,
//                         child: Container(
//                           width: 8,
//                           height: 8,
//                           decoration: const BoxDecoration(
//                             color: Color(0xFFEF4444),
//                             shape: BoxShape.circle,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   onPressed: () => _showNotificationSnackBar(context),
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 20),
//
//           // Store Selector & Date Picker Row
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Date Picker
//               _buildDatePicker(context),
//               const SizedBox(width: 16),
//               // Store Selector
//               _buildStoreSelector(context),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Date Picker Widget
//   Widget _buildDatePicker(BuildContext context) {
//     return GestureDetector(
//       onTap: () => _selectDate(context),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.15),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(
//               Icons.calendar_today_rounded,
//               color: Colors.white,
//               size: 12,
//             ),
//             const SizedBox(width: 8),
//             Flexible(
//               child: Text(
//                 DateFormat('yyyy/MM/dd', 'ar').format(widget.selectedDate),
//                 style: getSemiBoldStyle(color: Colors.white, fontSize: 14),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Store Selector Widget
//   Widget _buildStoreSelector(BuildContext context) {
//     return BlocBuilder<StoresCubit, StoresState>(
//       builder: (context, state) {
//         if (state is StoresSuccess) {
//           final stores = state.allStoresEntity.results ?? [];
//
//           if (selectedStore == null && stores.isNotEmpty) {
//             final cachedStoreId = CacheService.getData(key: CacheKeys.storeId);
//             selectedStore = stores.firstWhere(
//               (store) => store.id == cachedStoreId,
//               orElse: () => stores.first,
//             );
//           }
//
//           return Container(
//             padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.15),
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(
//                 color: Colors.white.withOpacity(0.3),
//                 width: 1,
//               ),
//             ),
//             child: DropdownButtonHideUnderline(
//               child: DropdownButton<Results>(
//                 value: selectedStore,
//                 icon: const Icon(
//                   Icons.keyboard_arrow_down_rounded,
//                   color: Colors.white,
//                   size: 16,
//                 ),
//                 dropdownColor: const Color(0xFF6366F1),
//                 borderRadius: BorderRadius.circular(12),
//                 style: getSemiBoldStyle(color: Colors.white, fontSize: 12),
//                 items: stores.map((store) {
//                   return DropdownMenuItem<Results>(
//                     value: store,
//                     child: Row(
//                       children: [
//                         const Icon(
//                           Icons.store_rounded,
//                           color: Colors.white,
//                           size: 12,
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           store.storeName ?? '',
//                           style: getSemiBoldStyle(
//                             color: Colors.white,
//                             fontSize: 10,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//                 onChanged: (Results? newStore) {
//                   if (newStore != null) {
//                     setState(() {
//                       selectedStore = newStore;
//                     });
//                     CacheService.setData(
//                       key: CacheKeys.storeId,
//                       value: newStore.id,
//                     );
//                     CacheService.setData(
//                       key: CacheKeys.storeName,
//                       value: newStore.storeName,
//                     );
//                     widget.onStoreChanged();
//                   }
//                 },
//               ),
//             ),
//           );
//         } else if (state is StoresLoading) {
//           return Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.15),
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 SizedBox(
//                   width: 16,
//                   height: 16,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                       Colors.white.withOpacity(0.8),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   'جاري التحميل...',
//                   style: getSemiBoldStyle(color: Colors.white, fontSize: 14),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         final storeName = CacheService.getData(key: CacheKeys.storeName);
//         return Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.15),
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Icon(Icons.store_rounded, color: Colors.white, size: 18),
//               const SizedBox(width: 8),
//               Flexible(
//                 child: Text(
//                   storeName ?? 'المتجر',
//                   style: getSemiBoldStyle(color: Colors.white, fontSize: 14),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   // Date Picker Dialog
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: widget.selectedDate,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//       locale: const Locale('ar'),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: const ColorScheme.dark(
//               primary: Color(0xFF6366F1),
//               onPrimary: Colors.white,
//               surface: Color(0xFF1E293B),
//               onSurface: Colors.white,
//             ),
//             dialogBackgroundColor: const Color(0xFF1E293B),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (picked != null && picked != widget.selectedDate) {
//       widget.onDateChanged(picked);
//     }
//   }
//
//   void _showProfileDialog(BuildContext context) {
//     final userName =
//         CacheService.getData(key: CacheKeys.userName) ?? 'المستخدم';
//     final userRole = CacheService.getData(key: CacheKeys.userRole) ?? 'موظف';
//
//     showDialog(
//       context: context,
//       builder: (context) =>
//           ProfileDialog(userName: userName, userRole: userRole),
//     );
//   }
//
//   void _showNotificationSnackBar(BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.info_outline, color: Colors.white),
//             const SizedBox(width: 12),
//             const Text('قيد التطوير'),
//           ],
//         ),
//         backgroundColor: const Color(0xFF6366F1),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }
// }
///
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:stock_up/core/resources/style_manager.dart';
import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';
import 'package:stock_up/features/Home/presentation/widgets/profile_dialog.dart';
import 'package:stock_up/features/Stores/data/models/response/all_stores_model.dart';
import 'package:stock_up/features/Stores/presentation/bloc/Stores_cubit.dart';

class DashboardHeaderSection extends StatefulWidget {
  final VoidCallback onStoreChanged;
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;

  const DashboardHeaderSection({
    super.key,
    required this.onStoreChanged,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  State<DashboardHeaderSection> createState() => _DashboardHeaderSectionState();
}

class _DashboardHeaderSectionState extends State<DashboardHeaderSection>
    with SingleTickerProviderStateMixin {
  Results? selectedStore;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width < 600) {
          return _buildMobileLayout(context, width);
        } else if (width < 1000) {
          return _buildTabletLayout(context, width);
        } else {
          return _buildDesktopLayout(context, width);
        }
      },
    );
  }

  // ==================== Mobile Layout ====================
  Widget _buildMobileLayout(BuildContext context, double width) {
    final isVerySmall = width < 360;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: EdgeInsets.all(isVerySmall ? 8 : 12),
        child: Column(
          children: [
            // User Info Card
            _buildUserCard(context, isCompact: true, isVerySmall: isVerySmall),
            SizedBox(height: isVerySmall ? 8 : 12),

            // Controls Row
            isVerySmall
                ? Column(
                    children: [
                      _buildDateCard(context, isCompact: true),
                      const SizedBox(height: 8),
                      _buildStoreCard(context, isCompact: true),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(child: _buildDateCard(context, isCompact: true)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildStoreCard(context, isCompact: true),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  // ==================== Tablet Layout ====================
  Widget _buildTabletLayout(BuildContext context, double width) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Top Row: User Info + Actions
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _buildUserCard(context, isCompact: false),
                ),
                const SizedBox(width: 12),
                _buildQuickActions(context),
              ],
            ),
            const SizedBox(height: 16),

            // Bottom Row: Controls
            Row(
              children: [
                Expanded(flex: 2, child: _buildDateCard(context)),
                const SizedBox(width: 12),
                Expanded(flex: 3, child: _buildStoreCard(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==================== Desktop Layout ====================
  Widget _buildDesktopLayout(BuildContext context, double width) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Side: User Info
            Expanded(flex: 4, child: _buildUserCard(context, isExpanded: true)),
            const SizedBox(width: 20),

            // Right Side: Controls
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildDateCard(context, isDesktop: true)),
                      const SizedBox(width: 12),
                      _buildQuickActions(context),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildStoreCard(context, isDesktop: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== User Card ====================
  Widget _buildUserCard(
    BuildContext context, {
    bool isCompact = false,
    bool isVerySmall = false,
    bool isExpanded = false,
  }) {
    final userName =
        CacheService.getData(key: CacheKeys.userName) ?? 'المستخدم';
    final userRole = CacheService.getData(key: CacheKeys.userRole) ?? 'موظف';

    return Container(
      padding: EdgeInsets.all(isVerySmall ? 12 : (isCompact ? 16 : 20)),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          GestureDetector(
            onTap: () => _showProfileDialog(context),
            child: Hero(
              tag: 'user_avatar',
              child: Container(
                width: isVerySmall ? 45 : (isCompact ? 55 : 65),
                height: isVerySmall ? 45 : (isCompact ? 55 : 65),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: isVerySmall ? 24 : (isCompact ? 28 : 32),
                ),
              ),
            ),
          ),
          SizedBox(width: isVerySmall ? 10 : (isCompact ? 14 : 18)),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  userName,
                  style: getBoldStyle(
                    color: Colors.white,
                    fontSize: isVerySmall ? 16 : (isCompact ? 18 : 22),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    userRole,
                    style: getRegularStyle(
                      color: Colors.white,
                      fontSize: isVerySmall ? 11 : (isCompact ? 12 : 13),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Notification Icon (compact mode only)
          if (isCompact && !isExpanded)
            _buildNotificationIcon(isSmall: isVerySmall),
        ],
      ),
    );
  }

  // ==================== Date Card ====================
  Widget _buildDateCard(
    BuildContext context, {
    bool isCompact = false,
    bool isDesktop = false,
  }) {
    final dateStr = DateFormat('dd MMM yyyy', 'ar').format(widget.selectedDate);
    final dayName = DateFormat('EEEE', 'ar').format(widget.selectedDate);

    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        padding: EdgeInsets.all(isCompact ? 10 : 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF4FD1C5).withOpacity(0.9),
              const Color(0xFF38B2AC).withOpacity(0.9),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4FD1C5).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: isCompact ? MainAxisSize.max : MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.calendar_month_rounded,
                color: Colors.white,
                size: isCompact ? 16 : 18,
              ),
            ),
            SizedBox(width: isCompact ? 5 : 10),

            // Date Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    dayName,
                    style: getRegularStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: isCompact ? 11 : 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dateStr,
                    style: getSemiBoldStyle(
                      color: Colors.white,
                      fontSize: isCompact ? 12 : 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Arrow
            Icon(
              Icons.arrow_drop_down_rounded,
              color: Colors.white,
              size: isCompact ? 18 : 22,
            ),
          ],
        ),
      ),
    );
  }

  // ==================== Store Card ====================
  Widget _buildStoreCard(
    BuildContext context, {
    bool isCompact = false,
    bool isDesktop = false,
  }) {
    return BlocBuilder<StoresCubit, StoresState>(
      builder: (context, state) {
        if (state is StoresSuccess) {
          final stores = state.allStoresEntity.results ?? [];

          if (selectedStore == null && stores.isNotEmpty) {
            final cachedStoreId = CacheService.getData(key: CacheKeys.storeId);
            selectedStore = stores.firstWhere(
              (store) => store.id == cachedStoreId,
              orElse: () => stores.first,
            );
          }

          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? 14 : 18,
              vertical: isCompact ? 12 : 14,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFED64A6).withOpacity(0.9),
                  const Color(0xFFD53F8C).withOpacity(0.9),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFED64A6).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.store_rounded,
                    color: Colors.white,
                    size: isCompact ? 18 : 20,
                  ),
                ),
                SizedBox(width: isCompact ? 5 : 14),

                // Dropdown
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Results>(
                      value: selectedStore,
                      isExpanded: true,
                      isDense: true,
                      icon: const Icon(
                        Icons.arrow_drop_down_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      dropdownColor: const Color(0xFFD53F8C),
                      borderRadius: BorderRadius.circular(12),
                      style: getSemiBoldStyle(
                        color: Colors.white,
                        fontSize: isCompact ? 13 : 15,
                      ),
                      items: stores.map((store) {
                        return DropdownMenuItem<Results>(
                          value: store,
                          child: Text(
                            store.storeName ?? '',
                            style: getSemiBoldStyle(
                              color: Colors.white,
                              fontSize: isCompact ? 13 : 15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (Results? newStore) {
                        if (newStore != null) {
                          setState(() {
                            selectedStore = newStore;
                          });
                          CacheService.setData(
                            key: CacheKeys.storeId,
                            value: newStore.id,
                          );
                          CacheService.setData(
                            key: CacheKeys.storeName,
                            value: newStore.storeName,
                          );
                          widget.onStoreChanged();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (state is StoresLoading) {
          return Container(
            padding: EdgeInsets.all(isCompact ? 14 : 18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFED64A6).withOpacity(0.9),
                  const Color(0xFFD53F8C).withOpacity(0.9),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'جاري التحميل...',
                  style: getSemiBoldStyle(
                    color: Colors.white,
                    fontSize: isCompact ? 13 : 15,
                  ),
                ),
              ],
            ),
          );
        }

        // Default State
        final storeName = CacheService.getData(key: CacheKeys.storeName);
        return Container(
          padding: EdgeInsets.all(isCompact ? 8 : 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFED64A6).withOpacity(0.9),
                const Color(0xFFD53F8C).withOpacity(0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(Icons.store_rounded, color: Colors.white, size: 24),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  storeName ?? 'المتجر',
                  style: getSemiBoldStyle(
                    color: Colors.white,
                    fontSize: isCompact ? 8 : 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==================== Quick Actions ====================
  Widget _buildQuickActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFFBD38D).withOpacity(0.9),
            const Color(0xFFF6AD55).withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFBD38D).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: _buildNotificationIcon(),
    );
  }

  Widget _buildNotificationIcon({bool isSmall = false}) {
    return IconButton(
      onPressed: () => _showNotificationSnackBar(context),
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(
        minWidth: isSmall ? 36 : 44,
        minHeight: isSmall ? 36 : 44,
      ),
      icon: Stack(
        children: [
          Icon(
            Icons.notifications_rounded,
            color: Colors.white,
            size: isSmall ? 22 : 26,
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: isSmall ? 8 : 10,
              height: isSmall ? 8 : 10,
              decoration: BoxDecoration(
                color: const Color(0xFFFF3B3B),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF3B3B).withOpacity(0.5),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Date Picker Dialog ====================
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('ar'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF4FD1C5),
              onPrimary: Colors.white,
              surface: Color(0xFF1A202C),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF1A202C),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != widget.selectedDate) {
      widget.onDateChanged(picked);
    }
  }

  void _showProfileDialog(BuildContext context) {
    final userName =
        CacheService.getData(key: CacheKeys.userName) ?? 'المستخدم';
    final userRole = CacheService.getData(key: CacheKeys.userRole) ?? 'موظف';

    showDialog(
      context: context,
      builder: (context) =>
          ProfileDialog(userName: userName, userRole: userRole),
    );
  }

  void _showNotificationSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white),
            const SizedBox(width: 12),
            const Text('لا توجد إشعارات جديدة'),
          ],
        ),
        backgroundColor: const Color(0xFF4FD1C5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
