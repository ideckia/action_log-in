import api.IdeckiaApi.ItemState;

@:jsRequire("../keyboard", "IdeckiaAction")
extern class ActionKeyboard {
	function new();
	function setup(props:Any, server:Any):Any;
	function execute(state:Any):js.lib.Promise<ItemState>;
}
