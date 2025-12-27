import 'package:u/utilities.dart';

import '../../../../../core/core.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../data/data.dart';
import 'change_customer_state_controller.dart';

class ChangeCustomerStatePage extends StatefulWidget {
  const ChangeCustomerStatePage({
    required this.customer,
    required this.onSubmitted,
    super.key,
  });

  final CustomerReadDto customer;
  final Function(CustomerReadDto customer) onSubmitted;

  @override
  State<ChangeCustomerStatePage> createState() => _ChangeCustomerStatePageState();
}

class _ChangeCustomerStatePageState extends State<ChangeCustomerStatePage> with ChangeCustomerStateController {
  @override
  void initState() {
    customer = widget.customer;
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 18,
        children: [
          Text(s.customerStatusInfo).bodyMedium().bold(),
          Row(
            spacing: 10,
            children: [
              UElevatedButton(
                width: context.width,
                title: CustomerStatus.dont_followed.getTitle(),
                backgroundColor: context.theme.hintColor,
                onTap: () {
                  changeCustomerStatus(
                    CustomerStatus.dont_followed,
                    onResponse: widget.onSubmitted,
                  );
                },
              ).expanded(),
              UElevatedButton(
                width: context.width,
                title: CustomerStatus.successful_sell.getTitle(),
                onTap: () {
                  changeCustomerStatus(
                    CustomerStatus.successful_sell,
                    onResponse: widget.onSubmitted,
                  );
                },
              ).expanded(),
            ],
          ),
        ],
      ),
    ).onTap(() => FocusManager.instance.primaryFocus!.unfocus());
  }
}
