package;

using api.IdeckiaApi;

typedef Props = {
	@:editable("prop_username", '')
	var username:String;
	@:editable("prop_password", "12345")
	var password:String;
	@:editable("prop_key_after_user", 'tab', ['tab', 'enter'])
	var key_after_user:String;
	@:editable("prop_user_pass_delay", 0)
	var user_pass_delay:UInt;
}

@:name("log-in")
@:description("action_descriptor")
@:localize
class LogIn extends IdeckiaAction {
	var usernameAction:ActionKeyboard;
	var tabAction:ActionKeyboard;
	var passwordAction:ActionKeyboard;
	var enterAction:ActionKeyboard;

	function createKeyboardAction(_props:Any) {
		try {
			var action = new ActionKeyboard();
			action.setup(_props, core);
			return action;
		} catch (e:Any) {
			core.dialog.error(Loc.error_title.tr(), Loc.error_body.tr());

			return null;
		}
	}

	override public function init(initialState:ItemState):js.lib.Promise<ItemState> {
		if (props.username != '') {
			usernameAction = createKeyboardAction({type_string: props.username});
			tabAction = createKeyboardAction({key_to_tap: props.key_after_user});
		}
		passwordAction = createKeyboardAction({type_string: props.password});
		enterAction = createKeyboardAction({key_to_tap: 'enter'});

		return super.init(initialState);
	}

	public function execute(currentState:ItemState):js.lib.Promise<ActionOutcome> {
		return new js.lib.Promise((resolve, reject) -> {
			if (passwordAction == null) {
				resolve(new ActionOutcome({state: currentState}));
				return;
			}

			inline function writePassword(state) {
				haxe.Timer.delay(() -> {
					passwordAction.execute(state).then(passwordState -> {
						enterAction.execute(passwordState.state).then(enterState -> {
							resolve(enterState);
						});
					});
				}, props.user_pass_delay);
			}

			if (props.username != '') {
				usernameAction.execute(currentState).then(usernameState -> {
					tabAction.execute(usernameState.state).then(tabState -> {
						writePassword(tabState.state);
					});
				});
			} else {
				writePassword(currentState);
			}
		});
	}
}
