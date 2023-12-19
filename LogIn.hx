package;

using api.IdeckiaApi;

typedef Props = {
	@:editable("The user name", '')
	var username:String;
	@:editable("The password", "12345")
	var password:String;
	@:editable("Writes 'username'->key_after_user->'password'->'enter'", 'tab', ['tab', 'enter'])
	var key_after_user:String;
	@:editable("Milliseconds to wait between username and password", 0)
	var user_pass_delay:UInt;
}

@:name("log-in")
@:description("Writes the given username and password for login (action 'keyboard'[http://github.com/ideckia/action_keyboard] required)")
class LogIn extends IdeckiaAction {
	var usernameAction:ActionKeyboard;
	var tabAction:ActionKeyboard;
	var passwordAction:ActionKeyboard;
	var enterAction:ActionKeyboard;

	function createKeyboardAction(_props:Any) {
		try {
			var action = new ActionKeyboard();
			action.setup(_props, server);
			return action;
		} catch (e:Any) {
			server.dialog.error('Log-in action',
				'Could not load the action "keyboard" from actions folder. You can download it from https://github.com/ideckia/action_keyboard/releases/tag/v1.0.0');

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
